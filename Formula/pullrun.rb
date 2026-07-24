class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.2"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.2/pullrun-0.7.2-darwin-arm64.tar.gz"
    sha256 "febef9113084d921a986545bc470341dfd4e4c5a8fb867660457367dffd13259"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.2/pullrun-0.7.2-darwin-amd64.tar.gz"
    sha256 "52a5c53bee436742a8576edb9c6ee771a0e8ddc06243938a1226e86ba9f8a698"
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