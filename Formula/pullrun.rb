class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.1"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.1/pullrun-0.7.1-darwin-arm64.tar.gz"
    sha256 "34900420526d1a9a13854f4972ce4e566f95c8808baa8df940f65521e377e9ae"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.1/pullrun-0.7.1-darwin-amd64.tar.gz"
    sha256 "f50356ceb4e64e0709fa1d215366360a5013ecbc0580678d5d27043d5850fcf1"
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