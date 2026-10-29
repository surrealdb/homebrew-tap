class SurrealDb < Formula
  desc "Scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"
  version "3.3.5"

  # The database alone, as the `surreal` formula installed it until 3.2.3. Its
  # executable is `surreal-db`, because `surreal` is now the CLI, which runs
  # this database for `surreal db …` when it finds it on PATH and has none of
  # its own installed.

  on_macos do
    on_arm do
      url "https://download.surrealdb.com/v3.3.5/surreal-v3.3.5.darwin-arm64.tgz"
      sha256 "534140236e7246d86969015ba9ae8dd2f7f8f277ed1412cb17f3d397f95a1090"
    end
    on_intel do
      url "https://download.surrealdb.com/v3.3.5/surreal-v3.3.5.darwin-amd64.tgz"
      sha256 "a274451b30cf639df3b180b0e82ab8f7c52bc5244fa66aa65155a085f3eb6d31"
    end
  end

  on_linux do
    on_arm do
      url "https://download.surrealdb.com/v3.3.5/surreal-v3.3.5.linux-arm64.tgz"
      sha256 "de945afaf48660a0d7370d7f631dc964a4cceb46b9cfe0c92ede9061df4cc5e6"
    end
    on_intel do
      url "https://download.surrealdb.com/v3.3.5/surreal-v3.3.5.linux-amd64.tgz"
      sha256 "8f3bc163405085343fc6db9746a8e0cd55503c939802ad2b35a466675a9c09cf"
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
