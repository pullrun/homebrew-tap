class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.6.6"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.6/pullrun-0.6.6-darwin-arm64.tar.gz"
    sha256 "50b3dd75e7f177a7cebed934a6e5f2d7c4b22539f42a43ad31cb1132f4207c1e"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.6.6/pullrun-0.6.6-darwin-amd64.tar.gz"
    sha256 "9a005c556446e4502cee9c1ee9eacc94605317dd0bba2a589de234319dcecd14"
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
