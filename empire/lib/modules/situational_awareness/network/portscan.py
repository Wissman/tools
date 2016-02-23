from lib.common import helpers

class Module:

    def __init__(self, mainMenu, params=[]):

        self.info = {
            'Name': 'Invoke-Portscan',

            'Author': ['Rich Lundeen'],

            'Description': ('Does a simple port scan using regular sockets, based '
                            '(pretty) loosely on nmap.'),

            'Background' : True,

            'OutputExtension' : None,
            
            'NeedsAdmin' : False,

            'OpsecSafe' : True,
            
            'MinPSVersion' : '2',
            
            'Comments': [
                'https://github.com/mattifestation/PowerSploit/blob/master/Recon/Invoke-Portscan.ps1'
            ]
        }

        # any options needed by the module, settable during runtime
        self.options = {
            # format:
            #   value_name : {description, required, default_value}
            'Agent' : {
                'Description'   :   'Agent to run module on.',
                'Required'      :   True,
                'Value'         :   ''
            },
            'Hosts' : {
                'Description'   :   "Hosts to scan.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'HostFile' : {
                'Description'   :   "Input hosts from file (on the target)",
                'Required'      :   False,
                'Value'         :   ''
            },
            'ExcludeHosts' : {
                'Description'   :   "Exclude thsee comma separated hosts.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'Ports' : {
                'Description'   :   "Comma separated ports to scan for.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'TopPorts' : {
                'Description'   :   "Scan for X top ports, default 50.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'SkipDiscovery' : {
                'Description'   :   "Switch. Treat all hosts as online.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'PingOnly' : {
                'Description'   :   "Switch. Ping only, don't scan for ports.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'Open' : {
                'Description'   :   "Switch. Only show hosts with open ports.",
                'Required'      :   False,
                'Value'         :   'True'
            },        
            'GrepOut' : {
                'Description'   :   "Greppable (.gnmap) output file.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'XmlOut' : {
                'Description'   :   ".XML output file.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'ReadableOut' : {
                'Description'   :   "Readable (.nmap) output file.",
                'Required'      :   False,
                'Value'         :   ''
            },
            'AllformatsOut' : {
                'Description'   :   "Output file of all formats.",
                'Required'      :   False,
                'Value'         :   ''
            }
        }

        # save off a copy of the mainMenu object to access external functionality
        #   like listeners/agent handlers/etc.
        self.mainMenu = mainMenu

        for param in params:
            # parameter format is [Name, Value]
            option, value = param
            if option in self.options:
                self.options[option]['Value'] = value


    def generate(self):

        # read in the common module source code
        moduleSource = self.mainMenu.installPath + "/data/module_source/situational_awareness/network/Invoke-Portscan.ps1"

        try:
            f = open(moduleSource, 'r')
        except:
            print helpers.color("[!] Could not read module source path at: " + str(moduleSource))
            return ""

        moduleCode = f.read()
        f.close()

        script = moduleCode

        script += "Invoke-PortScan -noProgressMeter -f"

        for option,values in self.options.iteritems():
            if option.lower() != "agent":
                if values['Value'] and values['Value'] != '':
                    if values['Value'].lower() == "true":
                        # if we're just adding a switch
                        script += " -" + str(option)
                    else:
                        script += " -" + str(option) + " " + str(values['Value']) 

        script += " | ? {$_.alive}| Select-Object HostName,@{name='OpenPorts';expression={$_.openPorts -join ','}} | ft -wrap | Out-String | %{$_ + \"`n\"}"
        
        return script
