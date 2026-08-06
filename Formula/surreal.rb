class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "3.2.3"
  url "https://download.surrealdb.com/v3.2.3/surreal-v3.2.3.darwin-universal.tgz"
  sha256 "7e5547a20e6a199569aaa9d505f9177fb1788bd135e5e54642235571d2c922f6"

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
