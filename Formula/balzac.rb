class Balzac < Formula
  desc "A blazingly fast static site generator"
  homepage "https://balzac.rs"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.11/balzac-aarch64-apple-darwin.tar.xz"
      sha256 "d2f0d3739682d03c3076d37c1401eda351066dcf1abfb6b2098f6bd2d553e71a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.11/balzac-x86_64-apple-darwin.tar.xz"
      sha256 "b73d07c760bd1ff2b3bb16e5cbf0610c45a61bbf8da22d7b4c01d409b772339b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.11/balzac-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ee994ca23ed5e4b95a4783519cf02897d9ce5f7e73bfc05a383a8439d0958a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.11/balzac-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "86ff1092ec736ceaa44362f3f02d34d631ef07352c5980788d7f65547703bdcd"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "balzac"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "balzac"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "balzac"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "balzac"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
