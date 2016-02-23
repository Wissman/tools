# -*- coding: binary -*-
RSpec.shared_examples_for 'an xor encoder' do |keysize|

  it "should encode one block" do
    # Yup it returns one of its arguments in an array... Because spoon.
    encoded, key = described_class.encode("A"*keysize, "A"*keysize)
    expect(encoded).to eql("\x00"*keysize)

    encoded, key = described_class.encode("\x0f"*keysize, "\xf0"*keysize)
    expect(encoded).to eql("\xff"*keysize)

    encoded, key = described_class.encode("\xf7"*keysize, "\x7f"*keysize)
    expect(encoded).to eql("\x88"*keysize)
  end

  it "should encode multiple blocks" do
    2.upto 50 do |count|
      encoded, key = described_class.encode("\xf7"*keysize*count, "\x7f"*keysize)
      expect(encoded).to eql("\x88"*keysize*count)
    end
  end

  if keysize > 1
    it "should deal with input lengths that aren't a multiple of keysize" do
      expect {
        encoded, key = described_class.encode("A"*(keysize+1), "A"*keysize)
        expect(encoded).to eql("\x00"*(keysize+1))
      }.not_to raise_error

      expect {
        encoded, key = described_class.encode("A"*(keysize-1), "A"*keysize)
        expect(encoded).to eql("\x00"*(keysize-1))
      }.not_to raise_error
    end
  end

end
