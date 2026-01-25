class Balzac < Formula
  desc "A blazingly fast static site generator"
  homepage "https://balzac.rs"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.8/balzac-aarch64-apple-darwin.tar.xz"
      sha256 "c19b297db7b41d5188ea69377b593a81e5a39a3c5e5a8b472fd8e975454ad083"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.8/balzac-x86_64-apple-darwin.tar.xz"
      sha256 "2cb567d3446f15e28f9b1d1c8a491c88ac4cee59cd1b0927e870378ba487d721"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.8/balzac-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4770c9b96b380aaf1a9a8d7d1131396fd1a9c08413183b9a71dadebdf1ab450"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.8/balzac-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23cfe655e4a28acbb8a6c8d63ac4042d862907fde7bcdd1cd38f396bf42ec34d"
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
