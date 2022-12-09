---
subtitle: On Windows (Preview)
---

To easily install the Crystal Preview on Windows you can use [Scoop](https://scoop.sh/). 
**Be aware of the fact that Crystal on Windows is** [**not yet complete**](https://github.com/crystal-lang/crystal/issues/5430).

Before you start the installation, you must ensure that the [required packages](https://github.com/neatorobito/scoop-crystal#requirements) are installed.

## Install

```bash
scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
scoop install crystal
```

## Upgrade

When a new Crystal version is released you can upgrade your system using:

```bash
scoop update
scoop update crystal
```

