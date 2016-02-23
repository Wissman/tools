# -*- coding:binary -*-
require 'spec_helper'

require 'rex/powershell'

RSpec.describe Rex::Powershell::Output do

  let(:example_script) do
    Rex::Text.rand_text_alpha(400)
  end

  let(:subject) do
    Rex::Powershell::Script.new(example_script)
  end

  let(:eof) do
    Rex::Text.rand_text_alpha(10)
  end

  describe "::to_s" do
    it 'should print the script' do
      expect(subject.to_s).to eq example_script
    end
  end

  describe "::size" do
    it 'should return the size of the script' do
      expect(subject.size).to eq example_script.size
    end
  end

  describe "::to_s_lineno" do
    it 'should print the script with line numbers' do
      expect(subject.to_s_lineno).to eq "0: #{example_script}"
    end
  end

  describe "::deflate_code" do
    it 'should zlib the code and wrap in powershell in uncompression stub' do
      compressed = subject.deflate_code
      expect(compressed.include?('IO.Compression.DeflateStream')).to be_truthy
      compressed =~ /FromBase64String\('([A-Za-z0-9\/+=]+)'\)/
      expect($1.size).to be < Rex::Text.encode_base64(example_script).size
      expect(compressed).to eq subject.code
    end

    it 'should append an eof marker if specified' do
      compressed = subject.deflate_code(eof)
      expect(compressed.include?("echo '#{eof}';")).to be_truthy
    end
  end

  describe "::encode_code" do
    it 'should base64 encode the code' do
      encoded = subject.encode_code
      expect(encoded).to eq subject.code
      encoded =~ /^([A-Za-z0-9\/+=]+)$/
      expect($1.size).to eq encoded.size
    end
  end

  describe "::gzip_code" do
    it 'should gzip the code and wrap in powershell in uncompression stub' do
      compressed = subject.gzip_code
      expect(compressed.include?('IO.Compression.GzipStream')).to be_truthy
      compressed =~ /FromBase64String\('([A-Za-z0-9\/+=]+)'\)/
      expect($1.size).to be < Rex::Text.encode_base64(example_script).size
      expect(compressed).to eq subject.code
    end

    it 'should append an eof marker if specified' do
      compressed = subject.gzip_code(eof)
      expect(compressed.include?("echo '#{eof}';")).to be_truthy
    end
  end

  describe "::compress_code" do
    it 'should gzip by default' do
      compressed = subject.compress_code
      expect(compressed.include?('IO.Compression.GzipStream')).to be_truthy
    end

    it 'should deflate if gzip is false' do
      compressed = subject.compress_code(nil,false)
      expect(compressed.include?('IO.Compression.DeflateStream')).to be_truthy
    end

    it 'should append an eof' do
      compressed = subject.compress_code(eof)
      expect(compressed.include?("echo '#{eof}';")).to be_truthy
    end
  end

  describe "::decompress_code" do
    it 'should locate the base64 string and decompress it when deflate is used' do
      compressed = subject.compress_code(nil, false)
      decompressed = subject.decompress_code
      expect(decompressed).to eq example_script
    end

    it 'should locate the base64 string and decompress it when gzip is used' do
      compressed = subject.compress_code
      decompressed = subject.decompress_code
      expect(decompressed).to eq example_script
    end

    it 'should raise a RuntimeException if the Base64 string is not compressed/corrupted' do
      corrupted = "FromBase64String('parp')"
      subject.code = corrupted
      expect { subject.decompress_code }.to raise_error(RuntimeError)
      expect(subject.code).to eq corrupted
    end
  end
end

