class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.3"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.3/pullrun-0.7.3-darwin-arm64.tar.gz"
    sha256 "945cf2e2cb7a246d6bc66aacc5369074724649d96b11112a58a58a076d9a42c0"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.3/pullrun-0.7.3-darwin-amd64.tar.gz"
    sha256 "e9f78d13b0ab146adbc9e7a7eb4d91e35625a7ed87d3b934891aae68d62e5ad3"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "pullrun-darwin-arm64" => "pullrun"
      bin.install "pullrun-runtime-darwin-arm64" => "pullrun-runtime"
      bin.install "pullrun-compose-darwin-arm64" => "pullrun-compose"
    else
      bin.install "pullrun-darwin-amd64" => "pullrun"
      bin.install "pullrun-runtime-darwin-amd64" => "pullrun-runtime"
      bin.install "pullrun-compose-darwin-amd64" => "pullrun-compose"
    end
  end

  service do
    run [opt_bin/"pullrun-runtime"]
    run_type :immediate
    keep_alive true
    process_type :background
  end

  test do
    system "#{bin}/pullrun", "--help"
    system "#{bin}/pullrun", "version"
    system "#{bin}/pullrun-runtime", "--help"
  end
end