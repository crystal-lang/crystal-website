---
title: Windows (Preview)
page_title: Install on Windows (Preview)
---

Crystal on Windows is currently distributed as both portable and installer preview packages. They are available on the [GitHub releases page](https://github.com/crystal-lang/crystal/releases). **Be aware that Crystal on Windows is** [**not yet complete**](https://github.com/crystal-lang/crystal/issues/5430).

## Install

Crystal can use either Microsoft Visual C++ or MinGW-w64 as the toolchain.

### Microsoft Visual C++ Toolchain

The MSVC variant of Crystal requires the following prerequisites:

- Microsoft Visual Studio build tools, which may be downloaded at one of the following locations:

  - [https://aka.ms/vs/17/release/vs_BuildTools.exe](https://aka.ms/vs/17/release/vs_BuildTools.exe)
  - [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/) (also includes the Visual Studio IDE)

  Either the "Desktop development with C++" workload or the "MSVC v143 - VS 2022 C++ x64/x86 build tools" components should be selected.
- Windows 10 SDK, which is available as a component from the above installers.
- [Developer mode is enabled](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development) in Windows Settings.

Next download a Crystal release file with `-msvc-` in its name (see above).

The `*-msvc-unsupported.zip` file is the portable package and can be extracted into any location. To use Crystal from that location, either call its `crystal.exe` directly, or
the installation directory can be manually added to the `PATH` environment variable.

The `*-msvc-unsupported.exe` file is the GUI installer; simply follow the instructions in the installation wizard. The GUI installer generates a warning if it detects that the above prerequisites aren't met.
By default it adds crystal to the `PATH` environment variable.

### MinGW-w64 Toolchain

It is highly recommended to use the MinGW-w64 variant of Crystal inside an MSYS2
shell, which sets up a toolchain automatically and provides a package manager.
See [Install on MSYS2](/install/on_msys2) for instructions.

Using Crystal without MSYS2 is also possible. The `*-gnu-unsupported.zip` file
is a portable package and can be extracted into any location. A separate,
standalone toolchain such as [WinLibs GCC](https://winlibs.com/) is required.
This package also does not come with the development libraries for Crystal's
third-party dependencies, so you are responsible for preparing them manually.

## Upgrade

Multiple portable packages can be installed side-by-side. They do not upgrade themselves, so any old versions need to be removed manually. **Do not simply extract a new portable package over an old one, as this will fail to remove files that are deleted in a version upgrade**.

Installing MSVC Crystal via the GUI installer automatically removes the previous installation.
