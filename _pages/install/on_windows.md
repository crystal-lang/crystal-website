---
title: Windows (Preview)
page_title: Install on Windows (Preview)
---

Crystal on Windows is currently distributed as both portable and installer preview packages. They are available on the [GitHub releases page](https://github.com/crystal-lang/crystal/releases). **Be aware that Crystal on Windows is** [**not yet complete**](https://github.com/crystal-lang/crystal/issues/5430).

## Install

Crystal on Windows requires the following prerequisites:

* Microsoft Visual Studio build tools, which may be downloaded at one of the following locations:

  * [https://aka.ms/vs/17/release/vs_BuildTools.exe](https://aka.ms/vs/17/release/vs_BuildTools.exe)
  * [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/) (also includes the Visual Studio IDE)

  Either the "Desktop development with C++" workload or the "MSVC v143 - VS 2022 C++ x64/x86 build tools" components should be selected.
* Windows 10 SDK, which is available as a component from the above installers.
* [Developer mode is enabled](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development) in Windows Settings.

The `.zip` file is the portable package and can be extracted into any location. To use Crystal from any location, the installation directory should be manually added to the `PATH` environment variable.

The `.exe` file is the GUI installer; simply follow the instructions in the installation wizard. The GUI installer generates a warning if it detects that the above prerequisites aren't met.

## Upgrade

Multiple portable packages can be installed side-by-side. They do not upgrade themselves, so any old versions need to be removed manually. **Do not simply extract a new portable package over an old one, as this will fail to remove files that are deleted in a version upgrade**.

Installing Crystal via the GUI installer automatically removes the previous installation.

## Scoop

A community bucket for the [Scoop package manager](https://scoop.sh/) is also available. Start by installing git (if you don't already have it available) and adding the Crystal repository:

```bash
scoop install git
scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
```

If you don't yet have the x64 Native Tools Command Prompt available, run this command:

```
scoop install vs_2022_cpp_build_tools
```

Finally:

```
scoop install crystal
```

When a new Crystal version is released you can upgrade your system using:

```bash
scoop update
scoop update crystal
```

Please see the [`neatorobito/scoop-crystal` repo](https://github.com/neatorobito/scoop-crystal) for more information and support.
