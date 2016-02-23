##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##


require 'msf/core'


###
#
# This class implements a "nop" generator for PHP payloads
#
###
class Metasploit3 < Msf::Nop

  def initialize
    super(
      'Name'        => 'PHP Nop Generator',
      'Alias'       => 'php_generic',
      'Description' => 'Generates harmless padding for PHP scripts',
      'Author'      => 'hdm',
      'License'     => MSF_LICENSE,
      'Arch'        => ARCH_PHP)
  end

  # Generate valid PHP code up to the requested length
  def generate_sled(length, opts = {})
    # Default to just spaces for now
    " " * length
  end

end
