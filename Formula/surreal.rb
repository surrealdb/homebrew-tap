class Surreal < Formula
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "0.1.26"
  url "https://download.surrealdb.com/surreal-v0.1.26.darwin-universal.tgz"
  sha256 "9be1c6cdacbabb49517bd6756d415e80c32b65e597d867ef8c1ce2ed13868528"

  bottle :unneeded

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

  plist_options :manual => "surreal start --log-level debug --path memory"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/surreal</string>
        <string>start</string>
        <string>--log-level=debug</string>
        <string>--path=file://#{var}/surreal.db</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/surreal version"
  end

end
