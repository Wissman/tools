# -*- coding: binary -*-

require 'rex/encoding/xor/dword'
require 'spec_helper'

RSpec.describe Rex::Encoding::Xor::Dword do
  it_behaves_like "an xor encoder", 4
end
