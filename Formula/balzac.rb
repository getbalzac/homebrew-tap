class Balzac < Formula
  desc "A blazingly fast static site generator"
  homepage "https://balzac.rs"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.9/balzac-aarch64-apple-darwin.tar.xz"
      sha256 "c57ac2d74ae24ccbab486cf493d520220fb28ad9a38a94de243fdda943aa7ed9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.9/balzac-x86_64-apple-darwin.tar.xz"
      sha256 "f5f97a0094f59edc747b95884cab22e92d7d9a348185c81145b95acdc765f90e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.9/balzac-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "364e51a2c359b3e9bd22b1e9684603f205d70308b30553ab12ae1dd07d5f90ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.9/balzac-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c96bb244902d824848805b95223382bb900e8816539ddbbaeec695e62b8ed6e7"
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
