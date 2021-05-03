#!/usr/bin/env bash

_help() {
  cat <<END

USAGE

    $ ./install.sh [--crystal=<crystal-version>] [--channel=stable|unstable|nightly]

  - crystal-version: latest, 1.0.0, 1.1 etc. (Default: latest)
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

  - wget (on Debian/Ubuntu when missing)
  - curl (on openSUSE when missing)
  - yum-utils (on CentOS/Fedora when using --crystal=x.y.z)

  This script source and issue-tracker can be found at:

  - https://github.com/crystal-lang/distribution-scripts/tree/master/packages/scripts/install.sh

END
}

set -eu

OBS_PROJECT=${OBS_PROJECT:-"devel:languages:crystal"}
DISTRO_REPO=${DISTRO_REPO:-}
CRYSTAL_VERSION="latest"
CHANNEL="stable"

_error() {
  echo >&2 "ERROR: $*"
}

_warn() {
  echo >&2 "WARNING: $*"
}

_check_version_id() {
  if [[ -z "${VERSION_ID}" ]]; then
    _error "Unable to identify distribution repository for ${ID}. Please, report to https://forum.crystal-lang.org/c/help-support/11"
    exit 1
  fi
}

_discover_distro_repo() {
  if [[ -r /etc/os-release ]]; then
    source /etc/os-release
  elif [[ -r /usr/lib/os-release ]]; then
    source /usr/lib/os-release
  else
    _error "Unable to identify distribution. Please, report to https://forum.crystal-lang.org/c/help-support/11"
    exit 1
  fi

  case "$ID" in
    debian)
      if [[ -z "${VERSION_ID:-}" ]]; then
        VERSION_ID="Unstable"
      elif [[ "$VERSION_ID" == "9" ]]; then
        VERSION_ID="$VERSION_ID.0"
      fi
      _check_version_id

      DISTRO_REPO="Debian_${VERSION_ID}"
      ;;
    ubuntu)
      _check_version_id
      DISTRO_REPO="xUbuntu_${VERSION_ID}"
      ;;
    fedora)
      _check_version_id
      if [[ "${VERSION}" == *"Prerelease"* ]]; then
        DISTRO_REPO="Fedora_Rawhide"
      else
        DISTRO_REPO="Fedora_${VERSION_ID}"
      fi
      ;;
    centos)
      _check_version_id
      DISTRO_REPO="CentOS_${VERSION_ID}"
      ;;
    rhel)
      _check_version_id
      DISTRO_REPO="RHEL_${VERSION_ID}"
      ;;
    opensuse-tumbleweed)
      DISTRO_REPO="openSUSE_Tumbleweed"
      ;;
    opensuse-leap)
      _check_version_id
      DISTRO_REPO="openSUSE_Leap_${VERSION_ID}"
      ;;
    *)
      _error "Unable to identify distribution. You may specify one with environment variable DISTRO_REPO"
      _error "Please, report to https://forum.crystal-lang.org/c/help-support/11"
      exit 1
      ;;
  esac
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
    _warn "Currently, only stable channel is available"
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

if [[ -z "${DISTRO_REPO}" ]]; then
  _discover_distro_repo
fi

_install_apt() {
  if [[ -z $(command -v wget &> /dev/null) ]] || [[ -z $(command -v gpg &> /dev/null) ]]; then
    apt-get update
    apt-get install -y wget gpg
  fi

  # Add repo signign key
  wget -qO- https://download.opensuse.org/repositories/${OBS_PROJECT}/${DISTRO_REPO}/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/devel_languages_crystal.gpg > /dev/null
  echo "deb http://download.opensuse.org/repositories/${OBS_PROJECT}/${DISTRO_REPO}/ /" | tee /etc/apt/sources.list.d/crystal.list
  apt-get update

  if [[ "$CRYSTAL_VERSION" == "latest" ]]; then
    apt-get install -y crystal
  else
    # Appending * allows --crystal=x.y and resolution of package-iteration https://askubuntu.com/a/824926/1101493
    apt-get install -y crystal="$CRYSTAL_VERSION*"
  fi
}

_install_rpm_key() {
  rpm --verbose --import https://build.opensuse.org/projects/${OBS_PROJECT}/public_key
}

_install_yum() {
  _install_rpm_key

  cat > /etc/yum.repos.d/crystal.repo <<EOF
[crystal]
name=Crystal (${DISTRO_REPO})
type=rpm-md
baseurl=https://download.opensuse.org/repositories/${OBS_PROJECT}/${DISTRO_REPO}/
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/${OBS_PROJECT}/${DISTRO_REPO}/repodata/repomd.xml.key
enabled=1
EOF

  if [[ "$CRYSTAL_VERSION" == "latest" ]]; then
    yum install -y crystal
  else
    command -v repoquery >/dev/null || yum install -y yum-utils
    CRYSTAL_PACKAGE=$(repoquery crystal-$CRYSTAL_VERSION* | tail -n1)
    if [ -z "$CRYSTAL_PACKAGE" ]
    then
      _error "Unable to find a package for crystal $CRYSTAL_VERSION"
    else
      yum install -y $CRYSTAL_PACKAGE
    fi
  fi
}

_install_dnf() {
  _install_rpm_key

  dnf config-manager --add-repo https://download.opensuse.org/repositories/${OBS_PROJECT}/$DISTRO_REPO/${OBS_PROJECT}.repo

  if [[ "$CRYSTAL_VERSION" == "latest" ]]; then
    dnf install -y crystal
  else
    command -v repoquery >/dev/null || dnf install -y dnf-utils
    CRYSTAL_PACKAGE=$(repoquery crystal-$CRYSTAL_VERSION* | tail -n1)
    if [ -z "$CRYSTAL_PACKAGE" ]
    then
      _error "Unable to find a package for crystal $CRYSTAL_VERSION"
    else
      dnf install -y $CRYSTAL_PACKAGE
    fi
  fi
}

_install_zypper() {
  if [[ -z $(command -v curl &> /dev/null) ]]; then
    zypper refresh
    zypper install -y curl
  fi

  _install_rpm_key
  zypper --non-interactive addrepo https://download.opensuse.org/repositories/${OBS_PROJECT}/$DISTRO_REPO/${OBS_PROJECT}.repo
  zypper --non-interactive refresh

  if [[ "$CRYSTAL_VERSION" == "latest" ]]; then
    zypper --non-interactive install crystal
  else
    zypper --non-interactive install crystal="$CRYSTAL_VERSION*"
  fi
}

# Add repo
case $DISTRO_REPO in
  Debian*)
    _install_apt
    ;;
  xUbuntu*)
    _install_apt
    ;;
  Fedora*)
    _install_yum
    ;;
  RHEL*)
    _install_yum
    ;;
  CentOS*)
    _install_yum
    ;;
  openSUSE*)
    _install_zypper
    ;;
  *)
    _error "Unable to install for $DISTRO_REPO. Please, report to https://forum.crystal-lang.org/c/help-support/11"
    exit 1
    ;;
esac
