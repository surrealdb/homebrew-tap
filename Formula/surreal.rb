class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "3.3.2"
  url "https://download.surrealdb.com/v3.3.2/surreal-v3.3.2.darwin-universal.tgz"
  sha256 "49dcb0523df3978850e7b95774e0dafffa608334dc284669f89d6c7232d3f53b"

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
