class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.5"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.5/pullrun-0.6.5-darwin-arm64.tar.gz"
    sha256 "a791a410631392cd6c083cd1b7212eababf7a6dcf1b13a73e3d03bc335a4fd2f"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.5/pullrun-0.6.5-darwin-amd64.tar.gz"
    sha256 "3e5b2c815410b38e67f48ae01763b744b77fc57b0dffbb5b8c6e093fd44d49e5"
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
