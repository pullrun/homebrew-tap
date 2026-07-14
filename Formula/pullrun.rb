class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.4"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.4/pullrun-0.6.4-darwin-arm64.tar.gz"
    sha256 "8fc5800eaec1a43fcb049c230429c067e5a549d194eca070be54c857bd2f39c0"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.4/pullrun-0.6.4-darwin-amd64.tar.gz"
    sha256 "e5324e76edf81fbcfdf1dc8ff1a744dab40e8128e09e3966f1b73d72adc6f79b"
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
