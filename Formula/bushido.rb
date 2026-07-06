class Bushido < Formula
  desc "High-performance CLI proxy that minimizes LLM token consumption (fork of rtk)."
  homepage "https://github.com/tedorigawa001/TokenReductionTool-BDO"
  version "0.44.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.6/bushido-aarch64-apple-darwin.tar.xz"
      sha256 "b8fe41cd49eb0a59088fba3c54d77bccb5c67eb7c606acb80fb2fd1c6acf3b96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.6/bushido-x86_64-apple-darwin.tar.xz"
      sha256 "be911604f4311a478fbd40fe22e16328a950193af0cc2675924567c776b33975"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.6/bushido-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ad97b2255f2f32a13946bf28e74195ab3bac00444e09320099a631f8f1862c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tedorigawa001/TokenReductionTool-BDO/releases/download/v0.44.6/bushido-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d5c763c97d3aaca3735d57b289aefeb8e382ce42fe6ceca64c27596dddeb260"
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
