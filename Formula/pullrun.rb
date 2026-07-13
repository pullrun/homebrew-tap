class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"

  url "https://github.com/pullrun/pullrun/releases/download/v0.3.4/pullrun-0.3.4-darwin-arm64.tar.gz"
  sha256 "1c4b0d417bb144c00abc5e2115141aafeacfc4b20d1d81cafa8cea6f4e55a8fd"
  version "0.3.4"

  def install
    bin.install "pullrun"
    bin.install "pullrun-runtime"
    bin.install "apple-virt-exec"
  end

  service do
    run [opt_bin/"pullrun-runtime"]
    run_type :immediate
    keep_alive true
    process_type :background
  end

  test do
    system "#{bin}/pullrun", "--help"
    system "#{bin}/pullrun-runtime", "--help"
  end
end
