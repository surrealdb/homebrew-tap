class SurrealNightly < Formula
  desc "Scalable, distributed, collaborative, document-graph database (nightly)"
  homepage "https://surrealdb.com"
  # The nightly is rebuilt under one URL, so it has no checksum to pin, and
  # Homebrew no longer lets a formula skip one. The CLI installs, verifies and
  # upgrades nightlies itself: `surreal install db@nightly`. Disabled, this is
  # never downloaded; the checksum is one past build's, for the formula to load.
  url "https://download.surrealdb.com/nightly/surreal-nightly.darwin-universal.tgz"
  version "nightly"
  sha256 "7210802961b1eca465bcda7d133db4ec89afef3f2dd237d5a988e5b0f606f209"

  disable! date: "2026-10-13", because: "is replaced by `surreal install db@nightly`", replacement_formula: "surreal"

  def install
    bin.install "surreal" => "surreal-nightly"
  end
end
