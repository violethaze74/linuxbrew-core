class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.58.0",
      revision: "b7f44919efb422f9ee5ccc2622351e8764b3123f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d909f637ead2bcd9b3d6c3896beb5e6504f1154fa3ef00abfe64d1d30d4c0fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "29c094ef01bb2d690a3b22f67043e16066d0ea561608e40c6160977da0998ae3"
    sha256 cellar: :any_skip_relocation, catalina:      "9c3d12a56c25711516d77f79c46e136da21286a00750ed8ff871c2e0f75bbceb"
    sha256 cellar: :any_skip_relocation, mojave:        "ec393d7a6ae44b221f36f6cf948633550a1437c1dc61133a481fe0065c13e3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5023669acc7b76f019be271053529c2432c62e67b53e671d19bf492824158d57" # linuxbrew-core
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
