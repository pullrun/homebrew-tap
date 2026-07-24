class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.3"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.3/pullrun-0.7.3-darwin-arm64.tar.gz"
    sha256 "7ff59cdb51a8ceb4bbd6176e83bbbcd6a84bfd98f706f7d389c91e64218279a7"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.3/pullrun-0.7.3-darwin-amd64.tar.gz"
    sha256 "cfd1a19037f9a00eb03dbf539ce98be499bf7a01f5b2448d1e1fe9fb7923db78"
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