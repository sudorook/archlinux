# Arch Linux Post-Installation

This is a set of scripts for running post-installation tasks for Arch Linux. It
is intended primarily for use with Cinnamon or GNOME desktop environments.

Depends on `wget` and `git`.

## Usage
```
./postinstall
```

The script will check if the dependencies are installed and if the network
connection is active. The rest should be self explanatory.


## Options
```
1) Quit                 4) Miscellaneous        7) Applications
2) Autopilot            5) Desktop environment  8) Themes
3) Base                 6) Network tools        9) Personalization
```

### 2) Autopilot

Automatically install (without prompting) packages and configs.

### 3) Base
```
1) Back                 4) Enable multilib      7) Disable system beep
2) Base packages        5) Sudo insults
3) Updates              6) Pacman styling
```

2) Installs [base.list](packages/base.list).

3) Updates system packages.

4) Enable multilib in `/etc/pacman.conf`.

5) Enable sudo insults for incorrect login attempts via `/etc/sudoers`. Pipes
   to `visudo` via `tee`, so it's safe.

6) Enable Color and ILoveCandy in `/etc/pacman.conf`.

7) Blacklist `pcskpr` and `snd_pcsp` kernel modules.

### 4) Miscellaneous
```
1) Back                   4) Linux LTS kernel       7) Laptop tools
2) All                    5) Linux zen kernel       8) zsh
3) Linux hardened kernel  6) Linux utilities
```

3) Install the `linux-hardened` kernel (with headers).

4) Install the `linux-lts` kernel (plus headers).

5) Install the `linux-zen` kernel (plus headers).

6) Install general command line utilities in [utils.list](packages/utils.list).

7) Install `tlp` for power management and `xorg-xbacklight` for screen
   brightness.

8) Install `zsh`, [fishy-lite](https://github.com/sudorook/fishy-lite), and
   change default shell to `zsh`.

### 5) Desktop environment
```
1) Back
2) All
3) GNOME
4) Cinnamon
```

3) Install GNOME desktop environment (with GDM for login).

4) Install Cinnamon desktop environment and Redshift (with LightDM for login).

### 6) Network tools
```
1) Back                    4) Tunnel pacman over tor
2) All                     5) Network tools
3) Install tor
```

3) Install `tor` and `torsocks` (no Tor Browser).

4) **EXPERIMENTAL** Tunnel all package updates through Tor.

5) Install NetworkManager, Samba, SSH, and UFW for networking management and
   security. Automatically sets NetworkManager to use random MAC addresses for
   network interfaces, enables Avahi daemon for local hostname resolution, and
   enables UFW firewall systemd unit. **DOES NOT** set default firewall rules.

### 7) Applications
```
1) Back                    7) Extra applications    13) Tor browser
2) All                     8) Emulators             14) Vim
3) Android tools           9) KVM (host)            15) VirtualBox (host)
4) General applications   10) KVM (guest)           16) VirtualBox (guest)
5) Codecs                 11) Music                 17) Wine
6) Development            12) TeX Live
```

3) Install packages in [android.list](packages/android.list) for accessing
   storage on Android devices.

4) Install general daily use applications from [apps.list](packages/apps.list).

5) Install GStreamer plugins for handing various media codecs.

6) Install packages for programming and software development.

7) Install extra, less used applications from [extra.list](packages/extra.list).

8) Install game system emulators.

9) Install Virt-Manager and tools for using KVM virtualization.

10) Install packages for Linux guests to enable host-to-guest sharing and
    adjustable display resolution.

11) Install applications for playing music (`mpd`, `ncmcpp`, `clementine`),
    computing replaygain (`bs1770gain`), and using Pandora (`pianobar`).

12) Install TeX libraries and Font Awesome icons.

13) Download and install the Tor browser. Edits the application launcher icon
    to look for "browser-tor".

14) Install `vim` and `vim-plugins` and then set the user vimrc.

15) Install VirtualBox and kernel modules (dkms) for running it (host).

16) Install kernel modules (dkms) and tools for VirtualBox guests.

17) Install Wine not-emulator, along with the Mono and browser and some audio
    libraries.

### 8) Themes
```
1) Back               4) Adapta (GTK)       7) Vim theme
2) All                5) Fonts              8) Thunderbird theme
3) Arc (GTK)          6) Papirus (icons)
```

3) Download, compile, and install a [fork](https://github.com/sudorook/arc-theme)
   of the [Arc GTK theme](https://github.com/horst3180/arc-theme).

4) Download, compile, and install a [fork](https://github.com/sudorook/adapta-gtk-theme)
   of the [Adapta GTK theme](https://github.com/adapta-project/adapta-gtk-theme).

5) Install Noto, Cantarell, Ubuntu, Dejavu, and Roboto fonts.

6) Install tweaked version of Papirus icon theme.

7) Set the default Vim theme to [colorific](https://github.com/sudorook/colorific.vim).

8) Install the [Monterail theme](https://github.com/spymastermatt/thunderbird-monterail)
   for Thunderbird.

### 9) Personalization
```
1) Back                              9) Import application dconf
2) All                              10) Import GNOME terminal profiles
3) Set Noto fonts                   11) Enable autologin
4) Select icon theme                12) Invert brightness
5) Select desktop theme             13) Disable PulseAudio suspend
6) Set dark GTK                     14) Add scripts
7) Import Cinnamon dconf            15) Select default kernel
8) Import GNOME dconf
```

3) Set default system fonts to Noto.

4) Select the system icon theme.

5) Select the system desktop theme.

6) Set applications to prefer the dark theme.

7) Import pre-defined dconf settings for Cinnamon.

8) Import pre-defined dconf settings for GNOME.

9) Import pre-defined dconf settings for applications.

10) Import terminal profiles (Light/Dark) via dconf.

11) Enable autologin for the current user.

12) Invert brightness via kernel command line options in the GRUB prompt.

13) Disable PulseAudio suspend (suspend can sometimes cause weird buzzing).

14) Download and install [general utility scripts](https://github.com/sudorook/misc-scripts).

15) Select the default boot kernel from the currently installed ones.
