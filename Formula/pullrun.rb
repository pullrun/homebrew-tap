class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  url "https://github.com/pullrun/pullrun/archive/refs/tags/v0.1.0.tar.gz"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "go" => :build
  depends_on "protobuf" => :build

  def install
    # Build Rust runtime
    system "cargo", "build", "--release", "--bin", "pullrun-runtime", "--manifest-path", "runtime/pullrun-runtime/Cargo.toml"
    bin.install "runtime/pullrun-runtime/target/release/pullrun-runtime"

    # Build Go CLI
    system "go", "build", "-o", "pullrun", "./cli/pullrun/"
    bin.install "pullrun"
  end

  test do
    system "#{bin}/pullrun", "--help"
    system "#{bin}/pullrun-runtime", "--help"
  end
end
