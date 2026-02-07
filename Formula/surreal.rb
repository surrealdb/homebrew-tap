class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "2.6.0"
  url "https://download.surrealdb.com/v2.6.0/surreal-v2.6.0.darwin-universal.tgz"
  sha256 "b478b4a3c6d4a4a39bebd846ab08c9bdb99775cc4f2d381b8c0b383ba686afc0"

  def install
    bin.install "surreal"
  end

  def caveats; <<~EOS
    For local development only, this formula ships a launchd config
    to start a single-node cluster that stores its data under:
      #{var}/
    The database is available on the default port of 8000:
      #{Formatter.url("http://localhost:8000")}
  EOS
  end

  service do
    run [
      opt_bin/"surreal", "start", "--user", "root", "--pass", "root", "--log", "debug", "file://#{var}/surreal.db"
    ]
    working_dir "#{var}"
    keep_alive true
  end

  test do
    system "#{bin}/surreal version"
  end

end
