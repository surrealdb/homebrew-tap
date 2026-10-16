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

### The database alone

To install only the database, with Homebrew upgrading it:

```bash
brew install surrealdb/tap/surreal-db
```

This is what `surreal` installed until 3.2.3. The executable is now
`surreal-db`, as `surreal` is the CLI:

```bash
surreal-db start memory
```

To have `launchd` start it and restart it at login, run:

```bash
brew services start surreal-db
```

The CLI runs this database for `surreal db …` while it has none of its own
installed.

### Nightly release

`surreal-nightly` is disabled. The CLI installs and upgrades nightly builds of
the database itself:

```bash
surreal install db@nightly
```
