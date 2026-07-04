class Bushido < Formula
  desc "Bushido (bdo) - High-performance CLI proxy to minimize LLM token consumption. Fork of rtk (Rust Token Killer)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool"
  version "0.44.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool/releases/download/v0.44.4/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "54e748c7ef30fb3b8cfaaf13c2ae921f07dbf64e874b352ff26abfe60522c9b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool/releases/download/v0.44.4/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "64818be8ab2deb521d77ae401d5eca0bb48c7712f8bef77924b822678346e2e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool/releases/download/v0.44.4/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ec766d06324fa94fe284fe50df46e945a9704bffa0de7729b674eecd9377388"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool/releases/download/v0.44.4/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d4a48912cbf7664c7a11ce7c0201ea1c3300741acde6dc874703231ccb353ea"
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
