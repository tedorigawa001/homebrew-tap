class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.50.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.50.9/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "822dea03c46fe4b724e8bdf8e9eff5bd9c363ec615d4ab693ffaa96e83023bbd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.50.9/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "444b0e240fae13bcfc35dbc7a9d3b7f94f3fb665493b1155af529a34df298146"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.50.9/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6667564389a8383610d2bec2c034b7acb5a83ad6964b8422af57c24450b495e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.50.9/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "432fff41f0445add91891743cd923d491c4d37bb1cd71d24dae0e834a9613c08"
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
