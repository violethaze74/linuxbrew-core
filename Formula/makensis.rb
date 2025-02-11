class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1-src.tar.bz2"
  sha256 "9b5d68bf1874a7b393432410c7e8c376f174d2602179883845d2508152153ff0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e189ee20201ab5362625cb677875aed597ad56b85da29ca4b67dbe21396c9f4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa8a346937316765bf9ffe7d532b08212fab4ae697aad7e23185baeabe280249"
    sha256 cellar: :any_skip_relocation, catalina:      "889d630bf8637f68e90a9591a373ee44bde8d9d6a9395171e024fdced27f26ef"
    sha256 cellar: :any_skip_relocation, mojave:        "b40f5a388f0dddeb2c3d274bdc43fbba6cc0a9f613d056f0981bc60350252448"
    sha256 cellar: :any_skip_relocation, high_sierra:   "fe92934c874a27ead142b769d1c1258c6fd3baa66f2f005cad3f57ccd759734f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ae544951ae954b512686ba78c4f191ca29bd0de88a427bf8c39c49816f01b6" # linuxbrew-core
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  uses_from_macos "zlib"

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1.zip"
    sha256 "d463ad11aa191ab5ae64edb3a439a4a4a7a3e277fcb138254317254f7111fba7"
  end

  def install
    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX=#{prefix}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      "SKIPUTILS=Makensisw,NSIS Menu,zip2exe",
      # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
      "STRIP=0",
      "VERSION=#{version}",
    ]
    on_linux { args << "APPEND_LINKFLAGS=-Wl,-rpath,#{rpath}" }

    system "scons", "makensis", *args
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
    system "#{bin}/makensis", "#{share}/nsis/Examples/bigtest.nsi", "-XOutfile /dev/null"
  end
end
