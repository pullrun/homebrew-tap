class Pullrun < Formula
  desc "Agent sandbox runtime: OCI images as microVMs, containers, or sandbox groups"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.10.4"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.10.4/pullrun-0.10.4-darwin-arm64.tar.gz"
    sha256 "b20026f5d19717f0acefcf37c65e196948898975f70be27a80108076dd993ca9"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.10.4/pullrun-0.10.4-darwin-amd64.tar.gz"
    sha256 "9b3d779e1d367bd2b78026896d47f06a10111418050e9aa1e91cfc8e2269bc0c"
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