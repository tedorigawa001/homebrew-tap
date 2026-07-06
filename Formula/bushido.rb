class Bushido < Formula
  desc "Bushido (bdo) - High-performance CLI proxy to minimize LLM token consumption. Fork of rtk (Rust Token Killer)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.44.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.5/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "30ad998bcb1e73bc85588ab514ec82f2733e6212cedca9ec069ae59a7b34b419"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.5/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "60b7ec1ad17825b59e115eca5d87ac0294ec4a31c1f806448b8870f9e97cb02b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.5/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6016dcec713a8926ded9279f337dca739fba263e3c474360d41fda7481c2500"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.5/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d78a93b40c357b2dde64fd37e34e5f22c5a5fe764563ea1a4ef07392cccd00d2"
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
