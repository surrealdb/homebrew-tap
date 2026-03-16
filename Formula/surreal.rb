class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "3.0.4"
  url "https://download.surrealdb.com/v3.0.4/surreal-v3.0.4.darwin-universal.tgz"
  sha256 "ea4ac52a2213168953d2605f08939fe3af0e45015b2a422a5cbd689e39dcef4d"

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
