# The SurrealDB Homebrew Tap

This is a custom [Homebrew](https://brew.sh) tap for SurrealDB.

## Install

You can add the custom tap in a MacOS terminal session using:

```
$ brew tap surrealdb/tap
```

Once the tap has been added locally, you can install SurrealDB with:

```
$ brew install surreal
```

Alternatively you can configure the tap and install the package in one command:

```
$ brew install surrealdb/tap/surreal
```

## Starting Surreal

### Start `surreal` manually

To start SurrealDB you can run:

```
$ surreal start --log-level debug --path memory
```

### Run `surreal` as a service

To have `launchd` start `surreal` and restart at login, run:

```
$ brew services start surreal
```

To stop the server instance run:

```
$ brew services stop surreal
```
