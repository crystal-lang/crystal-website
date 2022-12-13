---
subtitle: On OpenBSD
---

OpenBSD includes the Crystal compiler in the ports tree, starting from version OpenBSD 6.4.

Currently, it is only available for the `amd64` platform.

## Install Package

Crystal is available as a compiled package. However, it might not be the most recent version available. The package also includes `shards`.

```bash
doas pkg_add crystal
```

## Install Port

For building Crystal yourself, the required installation is available in the ports tree.

If the ports collection is not already installed, instructions to installing it can be found in the [OpenBSD Ports guide](https://www.openbsd.org/faq/ports/ports.html).

```bash
cd /usr/ports/lang/crystal
doas make clean install
```

To avoid building dependencies from source (which can take a long time), you can first install them from binary packages:

```bash
doas pkg_add llvm libiconv boehm-gc libevent2 pcre libyaml
```
