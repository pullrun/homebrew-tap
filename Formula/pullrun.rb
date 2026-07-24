class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.8"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.8/pullrun-0.6.8-darwin-arm64.tar.gz"
    sha256 "ef51c326ec56ef769e4154d8e580a975ed3c3d21b0d4786b0f9f1073da56129b"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.8/pullrun-0.6.8-darwin-amd64.tar.gz"
    sha256 "5e6b5a2ae8cf522a9c6c64018439c0844ef391c0a68f4b70fa6ef0589119b069"
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
