class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.5"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.5/pullrun-0.7.5-darwin-arm64.tar.gz"
    sha256 "efd1ccd319f0c14ac6df540f99d437fc6ac70ab5106c62304c7b4e4498061105"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.5/pullrun-0.7.5-darwin-amd64.tar.gz"
    sha256 "ca04ea51c26714e201ffd43f4a3f375b1880347d2127e644fb6314103e279a1d"
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
    (share/"pullrun").install "pullrun-initramfs.cpio.gz"
  end

  def post_install
    rt = "#{prefix}/bin/pullrun-runtime"
    plist = "#{prefix}/.entitlements.plist"
    File.write(plist, <<~XML)
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>com.apple.security.virtualization</key>
        <true/>
      </dict>
      </plist>
    XML
    system "codesign", "--force", "--sign", "-",
           "--entitlements", plist, "--options", "runtime", rt

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