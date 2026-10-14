# The SurrealDB Homebrew Tap

This is a custom [Homebrew](https://brew.sh) tap for SurrealDB.

### Latest release

You can install the SurrealDB CLI in one command:

```bash
brew install surrealdb/tap/surreal
```

This installs `surreal`, the command-line interface to SurrealDB and its
components. The formula is versioned by the CLI, and `brew upgrade` upgrades it.

The CLI installs and upgrades the database and every other component itself,
as it does when installed any other way. Install the database with:

```bash
surreal install db
```

### Nightly release

You can install the nightly release in one command:

```bash
brew install surrealdb/tap/surreal-nightly
```

### Starting Surreal

To start SurrealDB you can run:

```bash
surreal db start memory
```
