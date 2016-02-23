##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

  # Exploit mixins should be called first
  include Msf::Exploit::Remote::HttpClient
  include Msf::Auxiliary::WmapScanServer
  # Scanner mixin should be near last
  include Msf::Auxiliary::Scanner

  def initialize
    super(
      'Name'        => 'HTTP Cross-Site Tracing Detection',
      'Description' => 'Checks if the host is vulnerable to Cross-Site Tracing (XST)',
      'Author'       =>
        [
          'Jay Turla <@shipcod3>' , #Cross-Site Tracing (XST) Checker
          'CG' #HTTP TRACE Detection
        ],
      'License'     => MSF_LICENSE
    )
  end

  def run_host(target_host)

    begin
      res = send_request_raw({
        'uri'          => '/<script>alert(1337)</script>', #XST Payload
        'method'       => 'TRACE',
      })

      unless res
        vprint_error("#{rhost}:#{rport} did not reply to our request")
        return
      end

      if res.body.to_s.index('/<script>alert(1337)</script>')
        print_good("#{rhost}:#{rport} is vulnerable to Cross-Site Tracing")
        report_vuln(
          :host   => rhost,
          :port   => rport,
          :proto  => 'tcp',
          :sname  => (ssl ? 'https' : 'http'),
          :info   => "Vulnerable to Cross-Site Tracing",
        )
      else
        vprint_error("#{rhost}:#{rport} returned #{res.code} #{res.message}")
      end
    rescue ::Rex::ConnectionRefused, ::Rex::HostUnreachable, ::Rex::ConnectionTimeout
    rescue ::Timeout::Error, ::Errno::EPIPE
    end
  end
end
