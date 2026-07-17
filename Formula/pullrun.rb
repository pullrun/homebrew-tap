class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.6"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.6/pullrun-0.6.6-darwin-arm64.tar.gz"
    sha256 "271d143b46b4e9dc7c51a7a7e3cece192e75dc1c7565079aab218e38b98768ee"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.6/pullrun-0.6.6-darwin-amd64.tar.gz"
    sha256 "62d206bbf62906f33dd518c0920d0e8ca77c66c1f54d758d9f038401f22b53d0"
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
