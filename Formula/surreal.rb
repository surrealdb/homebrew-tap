class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "2.1.3"
  url "https://download.surrealdb.com/v2.1.3/surreal-v2.1.3.darwin-universal.tgz"
  sha256 "936e313312b57f6a37b8cef9ad40f8824d6b9234213ec74c6d6c9a0732c32dd7"

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
      #{opt_bin}/surreal start --user root --pass root debug file://#{var}/surreal.db
    ]
    working_dir #{var}
    keep_alive true
  end

  test do
    system "#{bin}/surreal version"
  end

end
