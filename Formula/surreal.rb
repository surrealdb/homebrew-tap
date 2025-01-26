class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "2.1.4"
  url "https://download.surrealdb.com/v2.1.4/surreal-v2.1.4.darwin-universal.tgz"
  sha256 "20d1e752ff9ba9e83cc3d0b809cb906ef89501b5e06c93108be42de0fd5d38f6"

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
