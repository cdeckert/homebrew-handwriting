# frozen_string_literal: true

# Homebrew formula for the native macOS handwriting command-line tool.
class HandwritingCli < Formula
  desc "Create handwritten PDF, PNG, and SVG files locally on Apple silicon"
  homepage "https://github.com/cdeckert/handwriting-synthesis"
  url "https://github.com/cdeckert/handwriting-synthesis/archive/a90a2e28c0a29bcd7c74e5c463280b552f136133.tar.gz"
  version "0.1.0"
  sha256 "cef6fcb99821df445a53c673c3a12005f31549141ffa2ef6971a1024883de38c"
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
