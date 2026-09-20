class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.45.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.5/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "80810f535e692b2c23d23740fc3743b4132776b0f91ee16897a2f810609fdf0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.5/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "006f848980d0737ea28b8a6ce145fe553c60ccbe997ea8df713946fa8354c340"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.5/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0807bc8e3ffe8e60217f3e76f6dbb6286f6e6c7ae58bae491bd8f75351abba8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.45.5/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b9156bea31c31486f16af91ce8b8dcf4bc7f2b010e20160d29835566e9fcacb"
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
