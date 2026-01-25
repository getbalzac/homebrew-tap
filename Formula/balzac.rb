class Balzac < Formula
  desc "A blazingly fast static site generator"
  homepage "https://balzac.rs"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.7/balzac-aarch64-apple-darwin.tar.xz"
      sha256 "13f7fb979af5ab862edd9b110eac6066e4242e412bdfdad06392ec5a0d6ece94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.7/balzac-x86_64-apple-darwin.tar.xz"
      sha256 "7e29eb613d3b8f10858df998bcc05f3709dc5c116591cdddb583c557a352519d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.7/balzac-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fbf22ccbbc3f79e6a518e81fd83d3b81e13329ba9f5a294cfcbcb4057112c0f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.7/balzac-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "38ea89adf685148b06ff0455cb81e85c2ef1bcb9144ab9b58a0cd93cec119493"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "balzac" if OS.mac? && Hardware::CPU.arm?
    bin.install "balzac" if OS.mac? && Hardware::CPU.intel?
    bin.install "balzac" if OS.linux? && Hardware::CPU.arm?
    bin.install "balzac" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
