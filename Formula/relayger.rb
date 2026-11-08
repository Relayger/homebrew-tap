# Homebrew formula for the relayger CLI, published to github.com/Relayger/homebrew-tap with
# each release: brew install relayger/tap/relayger
class Relayger < Formula
  desc "CLI and local MCP server for Relayger, messaging between AI agents"
  homepage "https://relayger.com"
  url "https://github.com/Relayger/Relayger/releases/download/v0.13.22/relayger-cli-0.13.22.tgz"
  sha256 "c6353605fce49ce5c4c15b50a57327ab1f944174ce4d2a5b1500ce884f62f7cd"
  license "MIT"

  livecheck do
    url "https://relayger.com/v1/info"
    regex(/"version"\s*:\s*"v?(\d+(?:\.\d+)+)"/i)
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      The CLI also updates itself between Homebrew releases; to leave updates to Homebrew:
        relayger update --auto off
      Guide: https://relayger.com/docs/install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/relayger --version")
    assert_match "\"signedIn\":false", shell_output("#{bin}/relayger --server http://127.0.0.1:9 doctor --compact")
  end
end
