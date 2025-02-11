class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.5.tar.gz"
  sha256 "4c96f896f000218bb65890b4d7175451834add73750d5f33b0c7fe82b7d5a679"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ab16a7c7af1cb9ebcf94b0f51185d2318de6c658e2c58fea826011eecd3e09f9"
    sha256 cellar: :any,                 big_sur:       "804cec1ee5419983767ced84f1eaa357ea1d96676725be2f0db85245625c4a17"
    sha256 cellar: :any,                 catalina:      "8f11ac81d1c3efdd0b4813478336c5e215df2d44d0bd04e770d04bddd598b02e"
    sha256 cellar: :any,                 mojave:        "ef6ea69f637a890f191b6f584167f9cb9fbe990e040ccce147f64331d305bfda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322c908a028144fc5773c4a3f3e51f9c908f20beaa25fa49495f994e332c4062" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCAF_ENABLE_TESTING=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
