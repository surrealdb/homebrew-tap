class SurrealDb < Formula
  desc "Scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"
  version "4.0.0"

  # The database alone, as the `surreal` formula installed it until 3.2.3. Its
  # executable is `surreal-db`, because `surreal` is now the CLI, which runs
  # this database for `surreal db …` when it finds it on PATH and has none of
  # its own installed.

  on_macos do
    on_arm do
      url "https://download.surrealdb.com/v4.0.0/surreal-v4.0.0.darwin-arm64.tgz"
      sha256 "9e0b48796d73308bc717936142b676f3c83c58980275f784e738051eca8f6a18"
    end
    on_intel do
      url "https://download.surrealdb.com/v4.0.0/surreal-v4.0.0.darwin-amd64.tgz"
      sha256 "7ef3eecf5b1a3e31928784e4a7a91f943ec8d882fe22df5cdf7e6c7b37ea771f"
    end
  end

  on_linux do
    on_arm do
      url "https://download.surrealdb.com/v4.0.0/surreal-v4.0.0.linux-arm64.tgz"
      sha256 "3d0feff9c3b56a05f168175bd1585e144093c36e740c32c40cf6e51d3466b81c"
    end
    on_intel do
      url "https://download.surrealdb.com/v4.0.0/surreal-v4.0.0.linux-amd64.tgz"
      sha256 "e910760179b9f13d0773ce98ac50f9a537051156365239284c2dc687adf3049d"
    end
  end

  def install
    bin.install "surreal" => "surreal-db"
  end

  def caveats
    <<~EOS
      The database is installed as `surreal-db`, not `surreal`:
        surreal-db start

      `surreal` is now the SurrealDB CLI, which installs and manages the
      database and its other components. To install it:
        brew install surrealdb/tap/surreal

      For local development only, this formula ships a service that starts a
      single-node database storing its data under:
        #{var}/surreal.db
      The database is available on the default port of 8000:
        #{Formatter.url("http://localhost:8000")}
    EOS
  end

  service do
    run [opt_bin/"surreal-db", "start", "--user", "root", "--pass", "root", "rocksdb://#{var}/surreal.db"]
    working_dir var
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surreal-db version")

    port = free_port
    pid = spawn bin/"surreal-db", "start", "--bind", "127.0.0.1:#{port}", "memory"
    begin
      ready = 30.times.any? do
        sleep 1
        quiet_system bin/"surreal-db", "is-ready", "--endpoint", "http://127.0.0.1:#{port}"
      end
      assert ready, "`surreal-db start` did not become ready"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
