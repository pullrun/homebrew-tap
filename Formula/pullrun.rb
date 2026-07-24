class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.7"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.7/pullrun-0.6.7-darwin-arm64.tar.gz"
    sha256 "92c4af4a07a0686ca3b8d9a9cc3d1fcc18ae0b87f924ffe69b2b27daa86bcea8"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.7/pullrun-0.6.7-darwin-amd64.tar.gz"
    sha256 "4a130022894384399f37f1472375d2311ef60d3eff7bfc30039629f0fc314e38"
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
