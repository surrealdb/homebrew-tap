class Surreal < Formula
  desc "Command-line interface for SurrealDB and its components"
  homepage "https://surrealdb.com"
  # Versioned by the CLI. Until 3.2.3 this formula installed the database and
  # carried its version, so the scheme is raised for `brew upgrade` to move
  # those installs onto the CLI, whose versions start lower.
  version "0.1.0"
  version_scheme 1

  # `surreal` is the CLI. It installs and upgrades the database and every other
  # component itself, into ~/.surrealdb, as it does when installed any other
  # way; only upgrading the CLI itself is left to Homebrew.

  on_macos do
    on_arm do
      url "https://download.surrealdb.com/cli/launcher/v0.1.0/surreal-v0.1.0.darwin-arm64.tgz"
      sha256 "79644d2b83de16bc95469847073172428771f22045510a3403cfbb72d57c97c9"
    end
    on_intel do
      url "https://download.surrealdb.com/cli/launcher/v0.1.0/surreal-v0.1.0.darwin-amd64.tgz"
      sha256 "ac02998e2f13df4067e3465dd37366e773bdff60152d95ad4f6ee55c40f47b25"
    end
  end

  on_linux do
    on_arm do
      url "https://download.surrealdb.com/cli/launcher/v0.1.0/surreal-v0.1.0.linux-arm64.tgz"
      sha256 "9b1291070d7e82f2272e27abe8c1894ca48f7f2b74028536780bec334214affe"
    end
    on_intel do
      url "https://download.surrealdb.com/cli/launcher/v0.1.0/surreal-v0.1.0.linux-amd64.tgz"
      sha256 "8a81fa0d59c7c447a0360c9ee4d403507db1dea26c1fc9577ce1b43dcd89ee59"
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

    version_output = shell_output("#{bin}/surreal --version")
    assert_match(/^Surreal CLI #{Regexp.escape(version.to_s)}$/, version_output)
    assert_match(/^\s*db\s+not installed$/, version_output)

    # `surreal install db` must be the CLI's to run under Homebrew, as the
    # caveats say. Offline it stops before any request, and says why: a CLI that
    # refused to manage components under Homebrew would name Homebrew instead.
    output = shell_output("#{bin}/surreal install db 2>&1", 9)
    assert_match "SURREAL_CLI_OFFLINE", output
  end
end
