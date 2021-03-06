RSpec.describe 'queen executable' do
  it "displays help without arguments" do
    banner = <<-EOS
Usage: queen [options] FILE|DIRECTORY...

Options
    -q, --quiet                      Display no warnings.
        --verbose                    Display more information.
        --debug                      Display debugging information.
    -v, --version                    Display version.
    -h, --help                       Display this help message.
EOS
    out, err, status = Open3.capture3("queen")

    expect(status.exitstatus).to eq(0)
    expect(out).to eq(banner)
    expect(err).to eq('')
  end

  it "checks a text file and reprimands" do
    file = fixtures_path('misspelling.txt')
    out, err, status = Open3.capture3("queen #{file}")

    expect(status.exitstatus).to eq(0)
    expect(err).to be_empty
    expect(out).to eq([
      "Reviewing 1 file\n",
      "Reprimands:\n",
      "spec/fixtures/misspelling.txt:1:12: cookei might not be spelled correctly. Spelling suggestions: cookie, Cooke, cooker, Coke, Cook, coke",
      "spec/fixtures/misspelling.txt:2:7: botle might not be spelled correctly. Spelling suggestions: bottle, bottler, Boyle, betel, Battle, Butler",
      "spec/fixtures/misspelling.txt:2:16: mikl might not be spelled correctly. Spelling suggestions: mi kl, mi-kl, milk, Mill, mill, mil",
      "",
      "1 file read, 3 reprimands given.\n"
    ].join("\n"))
  end
end
