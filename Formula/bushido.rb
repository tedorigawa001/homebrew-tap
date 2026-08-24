class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.45.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.0/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "a20df0fdd536ba761447276afd5e530ab489adcc55e05b1e300461fd6039cc7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.0/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "a377fd052d924e7795ad09b8249c55dbe7a7ddb649dc728afde2f1d239ced68b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.0/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42682bc68aafa54a208703c322219b4a76370799941957714a07f0a6e5a8084d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.0/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42cf63147855749970e5582b6a0be56de2809295a842c82526f703c0c05c4128"
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
