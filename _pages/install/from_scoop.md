---
title: Scoop
page_title: Install from Scoop
---

A community bucket for the [Scoop package manager](https://scoop.sh/) on Windows is available.
Start by installing git (if you don't already have it available) and adding the Crystal repository:

```powershell
scoop install git
scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
```

If you don't yet have the x64 Native Tools Command Prompt available, run this command:

```powershell
scoop install vs_2022_cpp_build_tools
```

Finally:

```powershell
scoop install crystal
```

When a new Crystal version is released you can upgrade your system using:

```powershell
scoop update
scoop update crystal
```

Please see the [`neatorobito/scoop-crystal` repo](https://github.com/neatorobito/scoop-crystal) for more information and support.
