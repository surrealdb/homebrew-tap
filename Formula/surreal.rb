class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "2.3.9"
  url "https://download.surrealdb.com/v2.3.9/surreal-v2.3.9.darwin-universal.tgz"
  sha256 "591a2abbb4083bb936574a2f4928556cc6cfbab42a2ae1cf9fc722ed09bc5104"

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
