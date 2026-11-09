class SurrealDb < Formula
  desc "Scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"
  version "4.0.1"

  # The database alone, as the `surreal` formula installed it until 3.2.3. Its
  # executable is `surreal-db`, because `surreal` is now the CLI, which runs
  # this database for `surreal db …` when it finds it on PATH and has none of
  # its own installed.

  on_macos do
    on_arm do
      url "https://download.surrealdb.com/v4.0.1/surreal-v4.0.1.darwin-arm64.tgz"
      sha256 "82ef9da958ccccbf13a7d8574208dbeec2ebf4f8732a510246c8d73ef6e3947d"
    end
    on_intel do
      url "https://download.surrealdb.com/v4.0.1/surreal-v4.0.1.darwin-amd64.tgz"
      sha256 "3659503199db7586216742ab1474d0d7202ed5a1e99eff1a7f619580f766397a"
    end
  end

  on_linux do
    on_arm do
      url "https://download.surrealdb.com/v4.0.1/surreal-v4.0.1.linux-arm64.tgz"
      sha256 "52b385d8894a61f650679fea21036f0261c4676e3b8e5a84ecb7e4a46baf8f66"
    end
    on_intel do
      url "https://download.surrealdb.com/v4.0.1/surreal-v4.0.1.linux-amd64.tgz"
      sha256 "9d9d26313bf3f1aeffd066def9493932c79053fc9bca8f1b39f83d511f65577d"
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
