class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.44.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.9/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "b01a5fe25c952df7691ee5314b82918e3282441464b29ce2e965044f4e979903"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.9/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "074cddc2e22075ffe5b6ee2a842b67a316bd7e5217d87193dbe64ffd9d4e7fd6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.9/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c4c9de76f734f84307045b2214c5b14df99b8c37cb86e8cea49741f5d7c354d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.9/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42d01c1fe877a2eddfcde6e7763e50ac29e2e4ea3167d91bb2e252264084e17d"
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
