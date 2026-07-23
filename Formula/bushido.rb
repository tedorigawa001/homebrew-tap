class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.44.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.10/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "ceacc43e21d5fd7a823962512243a484f14255f14cc956c5fb394cdb726ff9e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.10/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "dca93eea22457cf9a84a332a087930b876f967d74cf8e0cdfed2994627643b73"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.10/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c04013e36594f38b20eff00410c62fa623357d9072959b16797f0e15a94ce752"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.10/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e84f1db50a49c01b5301926f902fbdde62325acb055f75645701e63ca80e5fc4"
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
