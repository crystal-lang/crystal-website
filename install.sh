#!/usr/bin/env bash

_help() {
  cat <<END

USAGE

    $ ./install.sh [--crystal=<crystal-version>] [--channel=stable|unstable|nightly]

  - crystal-version: latest, 0.35, 0.34.0, 0.33.0, etc. (Default: latest)
  - channel: stable, unstable, nightly. (Default: stable)

REQUIREMENTS

  - Run as root
  - The following packages need to be installed already:
    - gnupg ca-certificates apt-transport-https (on Debian/Ubuntu)

NOTES

  The following files may be updated:

  - /etc/apt/sources.list.d/crystal.list (on Debian/Ubuntu)
  - /etc/yum.repos.d/crystal.repo (on CentOS/Fedora)

  The following packages may be installed:

  - yum-utils (on CentOS/Fedora when using --crystal=x.y.z)

  This script source and issue-tracker can be found at:

  - https://github.com/crystal-lang/distribution-scripts/tree/master/bintray/scripts/install.sh

END
}

set -eu

DISTRO_TYPE=""
CRYSTAL_VERSION="latest"
CHANNEL="stable"

_error() {
  echo >&2 "ERROR: $*"
}

_warn() {
  echo >&2 "WARNING: $*"
}

_match_etc_issue() {
  local _distro_type="$1"
  shift
  grep -qis "$*" /etc/issue && DISTRO_TYPE="$_distro_type"
}

# The DISTRO_TYPE detection script is based on https://github.com/icy/pacapt
_discover_distro_type() {
  _match_etc_issue "deb" "Debian" && return
  _match_etc_issue "deb" "Ubuntu" && return
  _match_etc_issue "rpm" "CentOS" && return
  _match_etc_issue "rpm" "Fedora" && return

  [[ -z "$DISTRO_TYPE" ]] || return

  if hash apt-get 2>/dev/null; then
    DISTRO_TYPE="deb"
  elif hash yum 2>/dev/null; then
    DISTRO_TYPE="rpm"
  else
    _error "Unable to identify distribution. Please, report to https://forum.crystal-lang.org/c/help-support/11"
    exit 1
  fi
}

if [[ $EUID -ne 0 ]]; then
  _error "This script must be run as root"
  exit 1
fi

# Parse --crystal=<VERSION> and --channel=<CHANNEL> arguments

for i in "$@"
do
case $i in
    --crystal=*)
    CRYSTAL_VERSION="${i#*=}"
    shift
    ;;
    --channel=*)
    CHANNEL="${i#*=}"
    shift
    ;;
    --help)
    _help
    exit 0
    shift
    ;;
    *)
    _warn "Invalid option $i"
    ;;
esac
done

_discover_distro_type

# Add repo
case $DISTRO_TYPE in
  deb)
    # Add repo metadata signign key (shared bintray signing key)
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
    echo "deb https://dl.bintray.com/crystal/deb all $CHANNEL" | tee /etc/apt/sources.list.d/crystal.list
    apt-get update
    ;;

  rpm)
    DISTRO="all"
    [[ $(rpm -E %{rhel}) == "6" ]] && DISTRO="el6"

    cat > /etc/yum.repos.d/crystal.repo <<END
[crystal]
name=Crystal
baseurl=https://dl.bintray.com/crystal/rpm/$DISTRO/x86_64/$CHANNEL
gpgcheck=0
repo_gpgcheck=1
gpgkey=http://bintray.com/user/downloadSubjectPublicKey?username=bintray
END
    ;;
esac

# Install Crystal
case "$DISTRO_TYPE-$CRYSTAL_VERSION" in
  deb-latest)
    apt-get install -y crystal
    ;;
  deb-*)
    # Appending * allows --crystal=x.y and resolution of package-iteration https://askubuntu.com/a/824926/1101493
    apt-get install -y crystal="$CRYSTAL_VERSION*"
    ;;

  rpm-latest)
    yum install -y crystal
    ;;
  rpm-*)
    command -v repoquery >/dev/null || yum install -y yum-utils
    CRYSTAL_PACKAGE=$(repoquery crystal-$CRYSTAL_VERSION* | tail -n1)
    if [ -z "$CRYSTAL_PACKAGE" ]
    then
      _error "Unable to find a package for crystal $CRYSTAL_VERSION"
    else
      yum install -y $CRYSTAL_PACKAGE
    fi
    ;;

esac

