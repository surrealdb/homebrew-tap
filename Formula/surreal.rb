class Surreal < Formula
  
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "1.0.0-beta.10"
  url "https://download.surrealdb.com/v1.0.0-beta.10/surreal-v1.0.0-beta.10.darwin-universal.tgz"
  sha256 "27dde6dd5ad7dca5d690f4c1e63d285a3afd17781576236b114a45e0c442c645"

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
