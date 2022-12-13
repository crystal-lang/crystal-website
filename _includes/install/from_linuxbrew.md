## Linuxbrew

If you have [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux) installed you're ready to install Crystal:

```bash
brew update
brew install crystal-lang
```

If you're planning to contribute to the language itself you might find useful to install LLVM as well. So replace the last line with:

```bash
brew install crystal-lang --with-llvm
```
