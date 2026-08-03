class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.44.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.11/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "38274e79c86e2e1fd0f89cd23bcc8af2bf2c772e013d358dffb112e9d67ea975"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.11/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "61bad53df16d2511a47c2fe2feab8e6dee001ec88a654b3c963dc3425531adc4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.11/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "38c54b73b20b94fb2a528b7c0a8aca6105cb9afec8f33fd716b549da5ff9539f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.11/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b98dc2ebe9a3253f788e50a99cc2d0fe34cafc1379e4f29196fa401e8d84daad"
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
