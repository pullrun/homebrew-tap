class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"

  url "https://github.com/pullrun/pullrun/releases/download/v0.1.0/pullrun-0.1.0-darwin-arm64.tar.gz"
  sha256 "1a9f6452f10585788eccdf43bb8b69ac1bd82ec57703ba0fea904af0ec631303"
  version "0.1.0"

  bottle :unneeded

  def install
    bin.install "bin/pullrun"
    bin.install "bin/pullrun-runtime"
    bin.install "bin/apple-virt-exec"
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
