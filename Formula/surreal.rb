class Surreal < Formula
  desc "A scalable, distributed, collaborative, document-graph database"
  homepage "https://surrealdb.com"

  version "1.0.0-beta.3"
  url "https://download.surrealdb.com/v1.0.0-beta.3/surreal-v1.0.0-beta.3.darwin-universal.tgz"
  sha256 "3c1b0b8f1b1acea1da15bb652ad81b2c667a369e43c96c357ac4a63737bfc4bf"

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

  plist_options :manual => "surreal start --user root --pass root --log debug memory"

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
        <string>--user</string>
        <string>root</string>
        <string>--pass</string>
        <string>root</string>
        <string>file://#{var}/surreal.db</string>
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
