##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

  include Msf::Auxiliary::Report
  include Msf::Exploit::Remote::Udp
  include Msf::Auxiliary::UDPScanner
  include Msf::Auxiliary::NTP
  include Msf::Auxiliary::DRDoS

  def initialize
    super(
      'Name'           => 'NTP Mode 7 GET_RESTRICT DRDoS Scanner',
      'Description'    => %q{
        This module identifies NTP servers which permit "reslist" queries and
        obtains the list of restrictions placed on various network interfaces,
        networks or hosts. The reslist feature allows remote
        attackers to cause a distributed, reflected denial of service (aka, "DRDoS" or
        traffic amplification) via spoofed requests. The more interfaces, networks
        or hosts with specific restrictions, the greater the amplification.
        requests.
      },
      'Author'         => 'Jon Hart <jon_hart[at]rapid7.com>',
      'References'     =>
        [
          ['URL', 'https://github.com/rapid7/metasploit-framework/pull/3696'],
          ['URL', 'http://r-7.co/R7-2014-12']
        ],
      'DisclosureDate' => 'Aug 25 2014',
      'License'        => MSF_LICENSE
    )
  end

  # Called for each response packet
  def scanner_process(data, shost, sport)
    @results[shost] ||= []
    @results[shost] << Rex::Proto::NTP::NTPPrivate.new(data)
  end

  # Called before the scan block
  def scanner_prescan(batch)
    @results = {}
    @probe = Rex::Proto::NTP.ntp_private(datastore['VERSION'], datastore['IMPLEMENTATION'], 16)
  end

  # Called after the scan block
  def scanner_postscan(batch)
    @results.keys.each do |k|
      response_map = { @probe => @results[k] }
      # TODO: check to see if any of the responses are actually NTP before reporting
      report_service(
        :host  => k,
        :proto => 'udp',
        :port  => rport,
        :name  => 'ntp'
      )

      peer = "#{k}:#{rport}"
      vulnerable, proof = prove_amplification(response_map)
      what = 'R7-2014-12 NTP Mode 7 GET_RESTRICT DRDoS'
      if vulnerable
        print_good("#{peer} - Vulnerable to #{what}: #{proof}")
        report_vuln({
          :host  => k,
          :port  => rport,
          :proto => 'udp',
          :name  => what,
          :refs  => self.references
        })
      else
        vprint_status("#{peer} - Not vulnerable to #{what}: #{proof}")
      end
    end
  end
end
