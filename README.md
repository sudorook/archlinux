# Arch Linux Installation

This is a set of scripts installing Arch Linux and running post-installation
tasks, e.g. installing a DE, packages, and config files. They are intended for
Cinnamon or GNOME desktop environments.

Requirements:
1. `wget`
2. `git`

## Install

The `install` script will install Arch Linux on a user-prompted block device.
Supports installations on hardware using UEFI or legacy BIOS and will set a GPT
partition table and ext4 filesystem. Other features, such as bootloader or
encryption, are set when prompted.

The OS can be configured for LVM-on-LUKS full-disk encryption or not. Using
GRUB will also encrypt the `/boot` directory and write a decryption key into
the initial ramdisk so that the password prompt only appears once. For
alternate bootloaders, the `boot` directory will remain unencrypted.

There is also the optional provision for creating a separate, unencrypted
partition of arbitrary size. Useful for creating shared filesystems readable on
Windows / MacOS for USB drive installations.

The rough partition scheme is:
```
1. BIOS compatibility parition, empty if GRUB not used (1 MiB)
2. EFI partition (500 MiB)
3. Share partition (optional)
4. Arch Linux system (Plain / LVM / LUKS-encrypted partitions or volumes)
   - swap
   - root
   - home (optional)
```

**Note:** The script uses `sgdisk` for partitioning, which uses binary (base 2)
units for specifying partition sizes. For example, 500M corresponds to 500
mebibytes, not 500 megabytes.

To run, (need to be root):
```
sudo ./install
```

### Options

Installation options will be queries as the script runs.

#### Partitioning
```
1) Back
2) LVM on LUKS
3) LVM
4) Plain
```

2) Installs on LUKS-encrypted partition. Partitions (e.g. root and home) are
   kept as logical volumes on the LUKS partition.
3) Installs on unencrypted LVM partition.
4) Installs everything on primary partitions.

#### Boot system
```
1) Back
2) GRUB
3) systemd-boot
4) EFISTUB
```

2) Installs GRUB, BIOS version of no EFI firmware is detected. Otherwise, the
   EFI version is installed.
3) systemd-boot (previously gummiboot) installs kernels in `/boot` and copies
   them over to `/efi`. Systemd path hoods are also installed to update kernel
   images and microcode in `/efi` after updates.
4) Not supported yet...

#### Etc.

The script will also prompt for:
1. Host name
2. User name
3. User password
4. (Optional) LUKS password
5. Locale (e.g. `en_US.UTF-8`)
6. Time zone (e.g. `America/Toronto`)

The script will then mount the partitions, set up chroot, download and install
all the `base` and `base-devel` packages via `pacstrap`, set up the specified
user account, lock the root account, and unmount everything.

## Post-install

Once the base system is installed, use the `./postinstall` script (as the user
account, not root), to install the remaining packages, themes, etc.

Simply run:
```
./postinstall
```

The script will check if the dependencies are installed and if the network
connection is active. The rest should be self explanatory.

### Options
```
1) Quit                 4) Miscellaneous        7) Applications
2) Autopilot            5) Desktop environment  8) Themes
3) Base                 6) Network tools        9) Personalization
```

#### 2) Autopilot

Automatically install (without prompting) packages and configs.

#### 3) Base
```
1) Back                   5) Firmware              9) Pacman styling
2) All                    6) Updates              10) Pacman parallel
3) Base packages          7) Enable multilib      11) Disable system beep
4) Mirrorlist             8) Sudo insults
```

3) Installs [base.list](packages/base.list).

4) Use `reflector` to select the fastest https mirrors.

5) Install firmware and CPU microcode.

6) Updates system packages.

7) Enable multilib in `/etc/pacman.conf`.

8) Enable sudo insults for incorrect login attempts via `/etc/sudoers`. Pipes
   to `visudo` via `tee`, so it's safe.

9) Enable Color and ILoveCandy in `/etc/pacman.conf`.

10) Enable `ParallelDownloads` in `/etc/pacman.conf`.

11) Blacklist `pcskpr` and `snd_pcsp` kernel modules.

#### 4) Miscellaneous
```
1) Back                     5) Linux RT kernel         9) Laptop tools
2) All                      6) Linux RT LTS kernel    10) zsh
3) Linux hardened kernel    7) Linux zen kernel
4) Linux LTS kernel         8) Linux utilities
```

3) Install the `linux-hardened` kernel (with headers).

4) Install the `linux-lts` kernel (plus headers).

5) Install the `linux-rt` kernel (plus headers).

6) Install the `linux-rt-lts` kernel (plus headers).

7) Install the `linux-zen` kernel (plus headers).

8) Install general command line utilities in [utils.list](packages/utils.list).

9) Install `tlp` for power management and `xorg-xbacklight` for screen
   brightness.

10) Install `zsh`, fish-like plugins, nerd fonts, and powerlevel10k theme.

#### 5) Desktop environment
```
1) Back
2) All
3) GNOME
4) Cinnamon
```

3) Install GNOME desktop environment (with GDM for login).

4) Install Cinnamon desktop environment and Gammastep (with LightDM for login).

#### 6) Network tools
```
1) Back                    4) Local discovery         7) Tunnel pacman over tor
2) All                     5) Firewall
3) Networking              6) Install tor
```

3) Install Network Manager and OpenSSH. Sets NetworkManager to use random MAC
   addresses for network interfaces.

4) Install Avahi and Samba and enable tools for local network hosting and
   discovery.

5) Install UFW for network firewall and set up basic rules.

6) Install `tor` and `torsocks` (no Tor Browser).

7) **EXPERIMENTAL** Tunnel all package updates through Tor.

#### 7) Applications
```
1) Back                    8) Extra applications    15) Printing
2) All                     9) Emulators             16) TeX Live
3) Android tools          10) KVM (host)            17) Tor browser
4) General applications   11) KVM (guest)           18) Vim
5) AUR applications       12) Messaging             19) VirtualBox (host)
6) Codecs                 13) MinGW                 20) VirtualBox (guest)
7) Development            14) Music                 21) Wine
```

3) Install packages in [android.list](packages/android.list) for accessing
   storage on Android devices.

4) Install general daily use applications from [apps.list](packages/apps.list).

5) Install [select packages](packages/aur.list) from the AUR.

6) Install GStreamer plugins for handing various media codecs.

7) Install packages for programming and software development.

8) Install extra, less used applications from [extra.list](packages/extra.list).

9) Install game system emulators.

10) Install Virt-Manager and tools for using KVM virtualization.

11) Install packages for Linux guests to enable host-to-guest sharing and
    adjustable display resolution.

12) Install IRC, email, and other messaging clients.

13) Install MinGW for Windows/Linux cross-platform compilation.

14) Install applications for playing music (`mpd`, `ncmcpp`, `clementine`),
    computing replaygain (`bs1770gain`), and using Pandora (`pianobar`).

15) Install CUPS, drivers, and applications for handling printers.

16) Install TeX libraries and Font Awesome icons.

17) Download and install the Tor browser. Edits the application launcher icon
    to look for "browser-tor".

18) Install `vim` and `vim-plugins` and then set the user vimrc.

19) Install VirtualBox and kernel modules (dkms) for running it (host).

20) Install kernel modules (dkms) and tools for VirtualBox guests.

21) Install Wine not-emulator, along with the Mono and browser and some audio
    libraries.

#### 8) Themes
```
1) Back                 5) Plata (GTK)         9) Colorific themes
2) All                  6) Materia (GTK )      10) Thunderbird theme
3) Arc (GTK)            7) Fonts               11) Timed backgrounds
4) Adapta (GTK)         8) Papirus (icons)
```

3) Download, compile, and install a [fork](https://github.com/sudorook/arc-theme)
   of the [Arc GTK theme](https://github.com/horst3180/arc-theme).

4) Download, compile, and install a [fork](https://github.com/sudorook/adapta-gtk-theme)
   of the [Adapta GTK theme](https://github.com/adapta-project/adapta-gtk-theme).

5) Download, compile, and install a [fork](https://gitlab.com/sudorook/plata-theme)
   of the [Plata GTK theme](https://gitlab.com/tista500/plata-theme).

6) Download, compile, and install a [fork](https://github.com/sudorook/materia-theme)
   of the [Materia GTK theme](https://github.com/nana-4/materia-theme).

7) Install Noto, Cantarell, Ubuntu, Dejavu, and Roboto fonts.

8) Install tweaked version of Papirus icon theme.

9) Install [colorific themes](https://github.com/sudorook/colorific.vim) for
   alacritty, gitk, kitty, Neovim, tmux, and Vim.

10) Install the [Monterail theme](https://github.com/spymastermatt/thunderbird-monterail)
    for Thunderbird.

11) Install [timed backgrounds](https://github.com/sudorook/timed-backgrounds)
    where transitions from day to night match sunrise/sunset times.

#### 9) Personalization
```
1) Back                            10) Import application dconf
2) All                             11) Import GNOME terminal profiles
3) Select system fonts             12) Enable autologin
4) Select icon theme               13) Invert brightness (i915)
5) Select desktop theme            14) Enable IOMMU (Intel)
6) Set dark GTK                    15) Disable PulseAudio suspend
7) Select login shell              16) Disable 802.11n
8) Import Cinnamon dconf           17) Add scripts
9) Import GNOME dconf              18) Select default kernel
```

3) Select the system font. (Noto or Roboto)

4) Select the system icon theme.

5) Select the system desktop theme.

6) Set applications to prefer the dark theme.

7) Select default login shell (Bash or Zsh).

8) Import pre-defined dconf settings for Cinnamon.

9) Import pre-defined dconf settings for GNOME.

10) Import pre-defined dconf settings for applications.

11) Import terminal profiles (Light/Dark) via dconf.

12) Enable autologin for the current user.

13) Invert brightness via kernel command line options in the GRUB prompt.

14) Enable Intel IOMMU for the i915 graphics driver. Helps fix blank displays
    for Haswell CPUs running kernels >=5.7.

15) Disable PulseAudio suspend (suspend can sometimes cause weird buzzing).

16) Disable 802.11n networking in iwlwifi. May help speed up poor 802.11ac
    connections.

17) Download and install [general utility scripts](https://github.com/sudorook/misc-scripts).

18) Select the default boot kernel from the currently installed ones.
