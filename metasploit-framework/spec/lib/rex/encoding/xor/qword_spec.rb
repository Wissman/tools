# -*- coding: binary -*-

require 'rex/encoding/xor/qword'
require 'spec_helper'

RSpec.describe Rex::Encoding::Xor::Qword do
  it_behaves_like "an xor encoder", 8
end
