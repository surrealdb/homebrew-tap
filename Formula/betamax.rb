class Betamax < Formula
  desc "Rust-first VHS-style terminal capture CLI"
  homepage "https://www.joshka.net/betamax/"
  version "0.1.7"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^betamax-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.7/betamax-0.1.7-aarch64-apple-darwin.tgz"
      sha256 "80d9d540b421cfa289307853c91246f9bf709a7c30ccbd9f5dd8c687e7208ad3"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.7/betamax-0.1.7-x86_64-apple-darwin.tgz"
      sha256 "971e20fc8efcba2b9216669704ad1b106f2eb43227945b143037cf9b8e54580b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.7/betamax-0.1.7-aarch64-unknown-linux-gnu.tgz"
      sha256 "5ae4f0517ad32c6ff5a7d47bb73c8093b4cffd1ab2393ee747e3e4533c127b5e"
    else
      url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.7/betamax-0.1.7-x86_64-unknown-linux-gnu.tgz"
      sha256 "83a22ed4b85f0ec32fffac5736cf59c6572fe46a8f8bdd927644d407aeac072f"
    end
  end

  def install
    bin.install "betamax"
  end

  def caveats
    <<~EOS
      Betamax's video output requires ffmpeg:
        brew install ffmpeg

      This formula installs Betamax's upstream binary release archive. Source builds
      require zig@0.15 because Betamax's vendored libghostty-vt build requires Zig
      0.15.2.
    EOS
  end

  test do
    assert_match "betamax #{version}", shell_output("#{bin}/betamax --version")
    assert_match "Rust-first VHS-style terminal capture CLI", shell_output("#{bin}/betamax --help")
  end
end
