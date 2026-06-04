class Balzac < Formula
  desc "A blazingly fast static site generator"
  homepage "https://balzac.rs"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.10/balzac-aarch64-apple-darwin.tar.xz"
      sha256 "842e1ec219553256956fa2c7e21369fc8f65c3d80c9e8be47962aa69f07f8a1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.10/balzac-x86_64-apple-darwin.tar.xz"
      sha256 "e739e92f83c2300d47363663d7774631ef85982ef5b898a7f4d7387b73566d68"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.10/balzac-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "69bbd4e5c1779c0cef6b6f76af9d1c8640c2702eaebfa40ddff798f85956c998"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.10/balzac-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d6b9afadacbdf6aaff0c1786eb7f57b5831db3e4a18f5c97c46169c749cb35d"
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
