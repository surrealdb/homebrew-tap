class SurrealNightly < Formula
  desc "Scalable, distributed, collaborative, document-graph database (nightly)"
  homepage "https://surrealdb.com"
  # The nightly is rebuilt under one URL, so it has no checksum to pin, and
  # Homebrew no longer lets a formula skip one. The CLI installs, verifies and
  # upgrades nightlies itself: `surreal install db@nightly`.
  url "https://download.surrealdb.com/nightly/surreal-nightly.darwin-universal.tgz"
  version "nightly"

  disable! date: "2026-10-14", because: "is replaced by `surreal install db@nightly`", replacement_formula: "surreal"

  def install
    bin.install "surreal" => "surreal-nightly"
  end
end
