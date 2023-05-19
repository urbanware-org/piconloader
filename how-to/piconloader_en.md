# *PiconLoader*

**Table of contents**
*   [Preface](#preface)
*   [Installation](#installation)
*   [Usage examples](#usage-examples)

----

## Preface

I wrote this script for a good friend of mine who asked me, if it was possible to automatically change the picon of a channel at a certain time in case it changes.

It was developed on a *Vu+ Duo2* satellite receiver, but may also work on other devices. However, I never tested that. The code behind the script is not that beautiful, but works. Of course, it still can be improved and also enhanced.

This project is distributed under the [MIT license](https://opensource.org/licenses/MIT), which can also be found inside the `LICENSE` file.

Installing and configuring *PiconLoader*, requires fundamental experience with *Linux*, its shell and the *vi* editor (not *Vim*, as it is not available on the system) for modifying files.

Notice that the improper use of shell commands as well as well as modifying certain files may cause data loss or even corrupt your system! Due to this, you have to be careful and understand what you are doing ("think before you type").

When connecting via SCP and SSH a username and password is required. The username is `root` and the password (required) can apparently be set via the *Change Root Password* plug-in for the receiver, maybe also another way.

The corresponding picon names for the channels can be determined with the *dreamboxEDIT* tool.

Please do not ask me any questions about the satellite receiver itself or the *dreamboxEDIT* software, as I neither own such a device nor have I used this software myself.

[Top](#piconloader)

## Installation

### Copy the archive file to the receiver

First of all, the archive containing the *PiconLoader* must be copied to the receiver.

The following instructions use the archive of version 1.0.3 for example. The version number is part of the archive file name. When installing a newer version, the file name in the commands must be adjusted, of course.

#### *Windows* systems

The archive file can be transferred to the receiver using the free and open-source *PSCP* tool (`pscp.exe`) which can be downloaded [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

Let's assume the archive `piconloader-1.0.3.tar` is located inside `C:\vu` on the local hard disk and the receiver has the IP address `192.168.1.1`. The corresponding command would look like this:

```
pscp.exe -scp C:\vu\piconloader-1.0.3.tar root@192.168.1.1:/media/hdd/
```

When using paths containing spaces, the path must be enclosed with double quotes (`"`), for example:

```
pscp.exe -scp "C:\Users\John Doe\Downloads\piconloader-1.0.3.tar" root@192.168.1.1:/media/hdd/
```

#### *Unix*-like systems (*Linux*, *BSD*, *MacOSX*)

Usually, these operating systems already include the `scp` command for transferring files.

Let's assume the archive `piconloader-1.0.3.tar` is located inside the `/home/user/Downloads` directory on the local hard disk and the receiver has the IP address `192.168.1.1`. The corresponding command would look like as follows:

```
scp /home/user/Downloads/piconloader-1.0.3.tar root@192.168.1.1:/media/hdd/
```

### Connect to the device via SSH

After the archive has been copied to the hard disk of the receiver, the next step is to establish an SSH connection to the device.

#### *Windows* systems

You may use the free and open-source tool called *PuTTY*, which can also be downloaded [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

Simply set the connection type to **SSH**, enter the IP address of the receiver and click **Open**.

#### *Unix*-like systems (*Linux*, *BSD*, *MacOSX*)

Usually, these operating systems already include the `ssh` command for establishing SSH connections.

```
ssh root@192.168.1.1
```

### Extract the archive on the receiver

After transferring the file, the archive must be extracted on the hard disk of the receiver. Switch to the corresponding directory:

```
cd /media/hdd
```

Inside this directory you can find the transferred archive and extract it as follows.

```
tar xvf piconloader-1.0.3.tar
```

After that, the directory `/media/hdd/piconloader` will be created which contains the relevant files as well as some empty sub-directories.

The archive file can now be deleted again:

```
rm piconloader-1.0.3.tar
```

### Set the executable flag

In order to use the script, it must be executable. This should already be the case, but if it is not (for whatever reason) you must set the executable flag manually.

If the script already is executable and you run following command anyway, it will have no effect.

```
chmod +x ./piconloader/piconloader.sh
```

### Add the required cronjob

The *PiconLoader* script must be triggered every minute using a cronjob (using init scripts did not work before). Running the script does not affect the performance of the device, neither when watching TV nor when doing HD recordings.

Edit the `/etc/cron/crontab/root` crontab file

```
vi /etc/cron/crontabs/root
```

and add the following line.

```
* * * * * sh /media/hdd/piconloader/piconloader.sh
```

When done, save and close the file.

The cronjob should already be applied after modifying the crontab file, but you can also manually apply it as follows:

```
crontab /etc/cron/crontabs/root
```

[Top](#piconloader)

## Usage examples

Notice that *PiconLoader* uses the 24-hour time format. So, for example, 4 PM is equal to 16:00 h.

Let's assume the channel *FooTV* is on from 6:30 AM (06:30 h) to 8:00 PM (20:00 h) and outside this time, *BarTV* is.

Get the picon file of *FooTV*. Which name the corresponding picon must have can be obtained with *dreamboxEDIT*, for example:

```
1_0_1_9999_436_1_C0000X_0_0_0.png
```

Then, get the picon file for *BarTV* and rename it as the picon of *FooTV* with a leading underscore (`_`).

```
_1_0_1_9999_436_1_C0000X_0_0_0.png
```

Now there is the following situation:

* `1_0_1_9999_436_1_C0000X_0_0_0.png`  (picon of *FooTV*)
* `_1_0_1_9999_436_1_C0000X_0_0_0.png` (picon of *BarTV*)

Copy both picons into `/media/hdd/` on the receiver (using `scp` or `pscp.exe`).

Back in the SSH session, switch to the `piconloader` directory:

```
cd /media/hdd/piconloader
```

Then, create the two directories for both times inside the `qhourly` sub-directory as follows. Notice that you have to use hyphens (`-`) instead of colons (`:`) usually used as time seperators, as colons are not supported in file or directory names on *FAT32* and *NTFS* file systems.

```
mkdir -p ./qhourly/06-30
mkdir -p ./qhourly/20-00
```

Move the picon from *FooTV* into the first directory:

```
mv /media/hdd/1_0_1_9999_436_1_C0000X_0_0_0.png ./qhourly/06-30
```

Then move the picon from *BarTV* into the second directory and rename the file so it has the same name as the file from *FooTV* (without the underscore). Moving and renaming is done with a single command:

```
mv /media/hdd/_1_0_1_9999_436_1_C0000X_0_0_0.png ./qhourly/20-00/1_0_1_9999_436_1_C0000X_0_0_0.png
```

At your television, switch to the channel where *FooTV* and *BarTV* are on. If you already are watching that channel, switch to another one (for about a minute) and back again. After that, the corresponding picon should be loaded, depending on the time.

To be precise, the picon file will be copied into the `/usr/share/enigma2/picon` directory where all picons are stored and overwrite the current one.

The daily and monthly way actually works the same, with the difference that there are different directories you need to copy the files to.

For example, to change a picon on January, 3rd, the picon file must be copied into the sub-directory `./daily/01-03`.

To monthly change a picon, in January the corresponding sub-directory would be `./monthly/01`.

[Top](#piconloader)

