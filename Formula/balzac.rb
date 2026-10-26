class Balzac < Formula
  desc "A blazingly fast static site generator"
  homepage "https://balzac.rs"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.12/balzac-aarch64-apple-darwin.tar.xz"
      sha256 "95d863309f04f0e1055eecfbfd082e5485b88006e405a03fb9fb195ff9ede1e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.12/balzac-x86_64-apple-darwin.tar.xz"
      sha256 "57fc4b588e098b50dc5526f03cbc503881f8fc244b07109f61355318b8c198cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.12/balzac-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6df396583a157765c2652ddb29e40366b4a2c58fa52ac451c6f4037dda635d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getbalzac/balzac/releases/download/v0.1.12/balzac-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c68b8be9ff25ab95720a7fd521ec634322f705d1df768c1c1d2c1204bdabaa73"
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
