# The SurrealDB Homebrew Tap

This is a custom [Homebrew](https://brew.sh) tap for SurrealDB.

### Latest release

You can install the package in one command:

```bash
brew install surrealdb/tap/surreal
```

### Nightly release

You can install the nightly release in one command:

```bash
brew install surrealdb/tap/surreal-nightly
```

### Starting Surreal

#### Start `surreal` manually

To start SurrealDB you can run:

```bash
surreal -vvv start memory
```

#### Run `surreal` as a service

To have `launchd` start `surreal` and restart at login, run:

```bash
brew services start surreal
```

To stop the server instance run:

```bash
brew services stop surreal
```