class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.51.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.51.1/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "a27391348bfde67f4efdb3e85e358363b15252145006301f30bba3be2e56ef4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.51.1/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "2a36038c8830451bc1da5f238cc49f97da7b43e64c6422b705fd1171ad13f646"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.51.1/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c79afe804cc8a83fd9553380441a0d7207832da787508d51218e9af28dcabe5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.51.1/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9187842337c39d94e32aece0fa8c377afb174096be19b07411987954e47601b6"
    end
  end
  license "Apache-2.0"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bdo"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bdo"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bdo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bdo"
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
