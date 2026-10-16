class Surreal < Formula
  desc "Command-line interface for SurrealDB and its components"
  homepage "https://surrealdb.com"
  # Versioned by the CLI. Until 3.2.3 this formula installed the database and
  # carried its version, so the scheme is raised for `brew upgrade` to move
  # those installs onto the CLI, whose versions start lower.
  version "1.0.0"
  version_scheme 1

  # `surreal` is the CLI. It installs and upgrades the database and every other
  # component itself, into ~/.surrealdb, as it does when installed any other
  # way; only upgrading the CLI itself is left to Homebrew.

  on_macos do
    on_arm do
      url "https://download.surrealdb.com/cli/launcher/v1.0.0/surreal-v1.0.0.darwin-arm64.tgz"
      sha256 "f9f724fb9eec78167612c2a9c8d60342f0d062a69d939bce325aaf0cb8145833"
    end
    on_intel do
      url "https://download.surrealdb.com/cli/launcher/v1.0.0/surreal-v1.0.0.darwin-amd64.tgz"
      sha256 "5e9f78e1c11cc067cb76e88baea19fee748cfd8bea8ce5c1d9bc7a295bedf246"
    end
  end

  on_linux do
    on_arm do
      url "https://download.surrealdb.com/cli/launcher/v1.0.0/surreal-v1.0.0.linux-arm64.tgz"
      sha256 "11f39393a479070329e41e3dae0008f7c43f98e43216cd63bdee240c1b8f7e38"
    end
    on_intel do
      url "https://download.surrealdb.com/cli/launcher/v1.0.0/surreal-v1.0.0.linux-amd64.tgz"
      sha256 "23b9f6d600455821fdf933dcb126e2fa571e458a400d20b31e007554bcc440fa"
    end
  end

  def install
    bin.install "surreal"
  end

  def caveats
    <<~EOS
      The database is not installed with the CLI. Install it, then start it:
        surreal install db
        surreal db start

      To have Homebrew provide the database instead, install `surreal-db`:
        brew install surrealdb/tap/surreal-db

      `surreal help` lists the other components, such as `surreal cloud`.
    EOS
  end

  test do
    ENV["SURREAL_CLI_HOME"] = testpath/".surreal"
    ENV["SURREAL_CLI_OFFLINE"] = "1"

    # `--version` is one line led by the version, which is how the CLI tells
    # which version of a component is installed; `--json` gives the same as a
    # document.
    assert_match(/\A#{Regexp.escape(version.to_s)} for \S+ on \S+$/, shell_output("#{bin}/surreal --version"))
    assert_equal version.to_s, JSON.parse(shell_output("#{bin}/surreal --version --json"))["version"]

    # `surreal list` reports each component, the database among them: with none
    # of its own, the CLI runs the one `surreal-db` puts on PATH.
    components = JSON.parse(shell_output("#{bin}/surreal list --json"))["components"]
    assert_includes components.map { |component| component["name"] }, "db"

    # `surreal install db` must be the CLI's to run under Homebrew, as the
    # caveats say. Offline it stops before any request, and says why: a CLI that
    # refused to manage components under Homebrew would name Homebrew instead.
    output = shell_output("#{bin}/surreal install db 2>&1", 9)
    assert_match "SURREAL_CLI_OFFLINE", output
  end
end
