class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.44.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.7/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "64ed9766d089c64879c270877bc8c32470ce7d988af15f15811cfcd5f676f253"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.7/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "b6fcb8eead8939869a43b3cf2aec0c30e50defcfa87cb59823f2f15038a285f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.7/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "765e274971724e73ddbd6f5de7fcde397bb6c2f3681aeaab83cb3560355c44bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.7/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ea7fd18070b209c3912063644447d278ddf8119233fd67e4dea619a32a56429e"
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
    bin.install "bdo" if OS.mac? && Hardware::CPU.arm?
    bin.install "bdo" if OS.mac? && Hardware::CPU.intel?
    bin.install "bdo" if OS.linux? && Hardware::CPU.arm?
    bin.install "bdo" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
