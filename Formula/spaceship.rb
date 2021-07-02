class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.12.25.tar.gz"
  sha256 "df337231e81019bec715e0ec610a2fb3f1a34f5ffdfeee4c48f0b5a518f786a5"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "84cbf8d704a36722bd004cf344d64f828e2458f182c3a4164305e1c925dbcf0f"
  end

  depends_on "zsh" => :test

  def install
    libexec.install "spaceship.zsh", "lib", "sections"
    zsh_function.install_symlink libexec/"spaceship.zsh" => "prompt_spaceship_setup"
  end

  test do
    ENV["SPACESHIP_CHAR_SYMBOL"] = "🍺"
    prompt = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p spaceship"
    assert_match ENV["SPACESHIP_CHAR_SYMBOL"], shell_output("zsh -c '#{prompt}'")
  end
end
