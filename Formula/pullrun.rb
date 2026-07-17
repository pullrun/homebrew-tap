class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.7"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.7/pullrun-0.6.7-darwin-arm64.tar.gz"
    sha256 "b63d4ad15288d949d6513f25a938970bd303e2a33c478898cbf0283412d3afff"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.7/pullrun-0.6.7-darwin-amd64.tar.gz"
    sha256 "7fdc5025c1f90a97306c748e660ecaedf59d4638a9524898302cb06c6434db97"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "pullrun-darwin-arm64" => "pullrun"
      bin.install "pullrun-runtime-darwin-arm64" => "pullrun-runtime"
    else
      bin.install "pullrun-darwin-amd64" => "pullrun"
      bin.install "pullrun-runtime-darwin-amd64" => "pullrun-runtime"
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
