class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.47.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.47.0/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "75fe4cae085e026f8275c63d1cbc6b4626659c4c91a231dd580b40e272cb370e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.47.0/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "b516f73f4ccd1ccfaf2be637b58826de6ce7cd123191b7dcbb74e72834433d81"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.47.0/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96c34ae359c19db759fc5a5196a8bec7579c5ad3114b510b7217057b27394e2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.47.0/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5cada598afee32a15b42509e40540464a87294fd0a99ca6e5987d9be7b65d2ba"
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
