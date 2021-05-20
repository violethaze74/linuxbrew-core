class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.7.tar.xz"
  sha256 "d082a2ce72c750f66b1a415abe3e852df2eae1e8af53010f4ac2ea261a478832"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2f1e757e28977c97256660eeee90f850450d27cb2918b9c1aeecf87783309956"
    sha256 cellar: :any, big_sur:       "0caba6b60380a9dd449971df682f875ea8f7f57777ab3859c80a1d03ac6e7734"
    sha256 cellar: :any, catalina:      "652d947c06d675a9c1945f7937b7862443c75b17eacf1d753af07425a30af892"
    sha256 cellar: :any, mojave:        "bea2ca5ade3269aa7d0bdeea604c1a25bdfebd36cd965108f74c0e06895e53b2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
