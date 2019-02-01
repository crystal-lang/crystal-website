# Updating sponsors

Sponsors data is grabbed from Bountysource API, OpenCollective API and manual entry.

1. Manually update `_data/others.json`

2. Update `_data/bountysource.json`. Extract `BS_TOKEN` from a browser ajax request. header: `Authorization: token ....`

```
$ crystal scripts/bountysource.cr -- $BS_TOKEN
```

3. Update `_data/opencollective.json`

```
$ crystal scripts/opencollective.cr
```

4. Merge sponsors `.json` files

```
$ crystal scripts/merge.cr
```

The `_data/[bountysource|opencollective].json` files will have a stable ordering to minimize diff.

The `_data/sponsors.csv` is ordered by level to display them in the website.

Sponsors in the homepage need to be input manually.
