class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.1.0"

  root_url "https://github.com/pullrun/pullrun/releases/download/v0.1.0"
  bottle do
    rebuild 0
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9f6452f10585788eccdf43bb8b69ac1bd82ec57703ba0fea904af0ec631303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9f6452f10585788eccdf43bb8b69ac1bd82ec57703ba0fea904af0ec631303"
  end

  def install
    bin.install Dir["bin/*"]
  end

  service do
    run [opt_bin/"pullrun-runtime"]
    run_type :immediate
    keep_alive true
    process_type :background
  end

  test do
    system "#{bin}/pullrun", "--help"
    system "#{bin}/pullrun-runtime", "--help"
  end
end
