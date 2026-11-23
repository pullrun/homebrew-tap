class Pullrun < Formula
  desc "Agent sandbox runtime: OCI images as microVMs, containers, or sandbox groups"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.10.2"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.10.2/pullrun-0.10.2-darwin-arm64.tar.gz"
    sha256 "3118eb0267ad717b032d865ea084365684597967810ebab789b6bac77f8c816e"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.10.2/pullrun-0.10.2-darwin-amd64.tar.gz"
    sha256 "cb243d5e20c739ec845e3c84cdcc74d51811c9d5f2844c1aa93185a4e6c5da79"
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