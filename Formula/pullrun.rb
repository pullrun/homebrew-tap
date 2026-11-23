class Pullrun < Formula
  desc "Agent sandbox runtime: OCI images as microVMs, containers, or sandbox groups"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.11.0"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.11.0/pullrun-0.11.0-darwin-arm64.tar.gz"
    sha256 "de3fcd36d5cb28d9d564f4870f3e28aa90966fbd215c4e9603124d82f94d1151"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.11.0/pullrun-0.11.0-darwin-amd64.tar.gz"
    sha256 "27f6b8258b888905a0c0b192faa9c8a65dc1fd50346b1099bd763f5196e61438"
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