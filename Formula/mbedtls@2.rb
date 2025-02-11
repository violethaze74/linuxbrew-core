class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.27.0.tar.gz"
  sha256 "4f6a43f06ded62aa20ef582436a39b65902e1126cbbe2fb17f394e9e9a552767"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development_2.x"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ad0abc939b4b50be556177673fe5bb3a08a4a8725936d106c0c2bf599b81387d"
    sha256 cellar: :any,                 big_sur:       "1ee8bd0e453c70b8751f9f1fb307e7915f0eaf22bfcc2c39c3fc75af9344d310"
    sha256 cellar: :any,                 catalina:      "fb6db7177cbeefc4478a32b1a1a78cc0442db7ec96cfc1760d15d221cea3b92d"
    sha256 cellar: :any,                 mojave:        "8c8611c1a3dec140495803b9dd847e1ef5dc044deab964181124309cd0be950a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5a8deee6c0d667e6b229939d7b205ec5cccf30b20ac195f412e164594f6e18" # linuxbrew-core
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                    *std_cmake_args
    system "make"
    system "make", "install"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f bin/"hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install bin/"mpi_demo"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/generic_sum SHA256 testfile.txt").strip
  end
end
