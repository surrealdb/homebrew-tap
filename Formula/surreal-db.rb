class SurrealDb < Formula
  desc "Scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"
  version "3.3.4"

  # The database alone, as the `surreal` formula installed it until 3.2.3. Its
  # executable is `surreal-db`, because `surreal` is now the CLI, which runs
  # this database for `surreal db …` when it finds it on PATH and has none of
  # its own installed.

  on_macos do
    on_arm do
      url "https://download.surrealdb.com/v3.3.4/surreal-v3.3.4.darwin-arm64.tgz"
      sha256 "d0b0afc47948a46ceac9db178d2a10a7eb21e1c4f219a74b3573c850122ed9fb"
    end
    on_intel do
      url "https://download.surrealdb.com/v3.3.4/surreal-v3.3.4.darwin-amd64.tgz"
      sha256 "0723b555340da2cee1e0cff6f95552438536eab8d984b91f227b3ce2d52a5006"
    end
  end

  on_linux do
    on_arm do
      url "https://download.surrealdb.com/v3.3.4/surreal-v3.3.4.linux-arm64.tgz"
      sha256 "978262fd9d1f3adfc5791031663855baf0a3cf8a89883428109734ba5a065811"
    end
    on_intel do
      url "https://download.surrealdb.com/v3.3.4/surreal-v3.3.4.linux-amd64.tgz"
      sha256 "6593071833ad9c85cf533cf70b1643eb08966c868f8624001e30839ea29a2689"
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
