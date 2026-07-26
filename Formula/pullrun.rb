class Pullrun < Formula
  desc "Next-gen container runtime with zero-copy DAG storage and P2P image sync"
  homepage "https://github.com/pullrun/pullrun"
  license "Apache-2.0"
  version "0.7.5"

  on_arm do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.5/pullrun-0.7.5-darwin-arm64.tar.gz"
    sha256 "729241cf5a2e733f6a5575878fa5af146f2a1ab26822306fbb96257c776d04dd"
  end
  on_intel do
    url "https://github.com/pullrun/pullrun/releases/download/v0.7.5/pullrun-0.7.5-darwin-amd64.tar.gz"
    sha256 "8b11301b2e4c5d97e24c1adae0bc818bbf145692761d7e9fb1118570da0eda79"
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

    initramfs_dir = Pathname.new(Dir.home) + ".pullrun/initramfs"
    initramfs_dir.mkpath
    cp "#{share}/pullrun/pullrun-initramfs.cpio.gz", initramfs_dir
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