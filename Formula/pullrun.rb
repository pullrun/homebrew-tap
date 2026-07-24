class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.0"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.0/pullrun-0.7.0-darwin-arm64.tar.gz"
    sha256 "92e60d1a3551ffaac1b43749a6aa83eda058e55e12d84ccb62f56fe8046cd980"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.0/pullrun-0.7.0-darwin-amd64.tar.gz"
    sha256 "9f7dfc4bf859c0add980846fc4969c152bf6aa9c9faae3a1de27e734512f36c5"
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
