# frozen_string_literal: true

# Homebrew formula for the native macOS handwriting command-line tool.
class HandwritingCli < Formula
  desc "Create handwritten PDF, PNG, and SVG files locally on Apple silicon"
  homepage "https://github.com/cdeckert/handwriting-synthesis"
  url "https://github.com/cdeckert/handwriting-synthesis/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9f137a8b5fbd388499f2df9f3aeccbbc06b88b521cc5f0b4ddb631653020a446"
  head "https://github.com/cdeckert/handwriting-synthesis.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sonoma

  def install
    cd "macos/HandwritingCLI" do
      system "swift", "build", "--configuration", "release", "--disable-sandbox"

      libexec.install ".build/release/handwriting-cli"
      libexec.install ".build/release/HandwritingCLI_HandwritingCore.bundle"
    end

    bin.write_exec_script libexec/"handwriting-cli"
  end

  test do
    output = shell_output(
      "#{bin}/handwriting-cli --engine unicode --text 'Grüße aus Zürich' --output test.pdf",
    )

    assert_match '"engine" : "unicode"', output
    assert_match '"pages" : 1', output
    assert_path_exists testpath/"test.pdf"
    assert_equal "%PDF", (testpath/"test.pdf").binread(4)
  end
end
