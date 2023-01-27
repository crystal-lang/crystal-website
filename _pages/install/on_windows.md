---
subtitle: On Windows (Preview)
---

To easily install Crystal on Windows you can use the [Scoop](https://scoop.sh/) preview package. 
**Be aware of the fact that Crystal on Windows is** [**not yet complete**](https://github.com/crystal-lang/crystal/issues/5430).

## Requirements
* Developer mode [enabled](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development) in Settings
* [Scoop](https://scoop.sh/)

## Install
Start by installing git and adding the crystal repository:

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

## Upgrade

When a new Crystal version is released you can upgrade your system using:

```bash
scoop update
scoop update crystal
```

## Troubleshooting
Please see this [repo](https://github.com/neatorobito/scoop-crystal) for more information and support.

