# Arch Linux Installation

This is a set of scripts installing Arch Linux and running post-installation
tasks, e.g. installing a desktop environment, packages, and config files. They
are intended for Cinnamon, GNOME, and KDE.

Requirements:

1. `curl`
2. `findutils`
3. `fzf`
4. `git`
5. `grep`
6. `sed`

## Install

The `install` script will install Arch Linux on a user-prompted block device.
Supports installations on hardware using UEFI or legacy BIOS and will set a GPT
partition table and ext4 filesystem. Other features, such as bootloader or
encryption, are set when prompted.

The OS can be configured for LVM-on-LUKS full-disk encryption or not. Using GRUB
will also encrypt the `/boot` directory and write a decryption key into the
initial ramdisk so that the password prompt only appears once. For alternate
bootloaders, the `boot` directory will remain unencrypted.

There is also the optional provision for creating a separate, unencrypted
partition of arbitrary size. Useful for creating shared filesystems readable on
Windows / MacOS for USB drive installations.

The rough partition scheme is:

```
1. BIOS compatibility partition, empty if GRUB not used (1 MiB)
2. EFI partition (512 MiB)
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

```sh
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

2. Installs on LUKS-encrypted partition. Partitions (e.g. root and home) are
   kept as logical volumes on the LUKS partition.
3. Installs on unencrypted LVM partition.
4. Installs everything on primary partitions.

#### Boot system

```
1) Back
2) GRUB
3) systemd-boot
4) EFISTUB
```

2. Installs GRUB, BIOS version if no EFI firmware is detected. Otherwise, the
   EFI version is installed.
3. systemd-boot (previously gummiboot) installs kernels in `/boot` and copies
   them over to `/efi`. SystemD path hooks are also installed to update kernel
   images and microcode in `/efi` after updates.
4. Not supported yet...

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

```sh
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

3. Installs [base.list](packages/base.list).

4. Use `reflector` to select the fastest https mirrors.

5. Install firmware and CPU microcode.

6. Updates system packages.

7. Enable multilib in `/etc/pacman.conf`.

8. Enable sudo insults for incorrect login attempts via `/etc/sudoers`. Pipes to
   `visudo` via `tee`, so it's safe.

9. Enable Color and ILoveCandy in `/etc/pacman.conf`.

10. Enable `ParallelDownloads` in `/etc/pacman.conf`.

11. Blacklist `pcskpr` and `snd_pcsp` kernel modules.

#### 4) Miscellaneous

```
1) Back                     5) Linux RT kernel         9) Laptop tools
2) All                      6) Linux RT LTS kernel    10) Plymouth
3) Linux hardened kernel    7) Linux zen kernel       10) zsh
4) Linux LTS kernel         8) Linux utilities
```

3. Install the `linux-hardened` kernel (with headers).

4. Install the `linux-lts` kernel (plus headers).

5. Install the `linux-rt` kernel (plus headers).

6. Install the `linux-rt-lts` kernel (plus headers).

7. Install the `linux-zen` kernel (plus headers).

8. Install general command line utilities in [utils.list](packages/utils.list).

9. Install `tlp` for power management and `xorg-xbacklight` for screen
   brightness.

10. Install Plymouth splash screen.

11. Install `zsh`, fish-like plugins, nerd fonts, and powerlevel10k theme.

#### 5) Desktop environment

```
1) Back
2) All
3) GNOME
4) Cinnamon
5) KDE
```

3. Install GNOME desktop environment (with GDM for login).

4. Install Cinnamon desktop environment and Gammastep (with LightDM for login).

5. Install KDE desktop environment (with SDDM for login).

#### 6) Network tools

```
1) Back                    4) Local discovery         7) Tunnel pacman over tor
2) All                     5) Firewall
3) Networking              6) Install tor
```

3. Install Network Manager and OpenSSH. Sets NetworkManager to use random MAC
   addresses for network interfaces.

4. Install Avahi and Samba and enable tools for local network hosting and
   discovery.

5. Install UFW for network firewall and set up basic rules.

6. Install `tor` and `torsocks` (no Tor Browser).

7. **EXPERIMENTAL** Tunnel all package updates through Tor.

#### 7) Applications

```
 1) Back                            16) KVM (host)
 2) All                             17) KVM (guest)
 3) 3D acceleration                 18) Messaging
 4) Android tools                   19) MinGW
 5) General applications            20) Music
 6) General applications (AUR)      21) Printing
 7) General KDE applications        22) PipeWire
 8) General KDE applications (AUR)  23) TeX Live
 9) Codecs                          24) Tor browser
10) Containers                      25) Vim
11) Development                     26) Neovim
12) Development (AUR)               27) LazyVim (Neovim)
13) Extra applications              28) VirtualBox (host)
14) Extra KDE applications          29) VirtualBox (guest)
15) Emulators                       30) Wine
```

3. Install 3D video acceleration packages in
   [3d-accel.list](packages/3d-accel.list).

4. Install packages in [android.list](packages/android.list) for accessing
   storage on Android devices.

5. Install general GTK applications from [apps.list](packages/apps.list).

6. Install general GTK AUR applications from
   [apps-aur.list](packages/apps-aur.list).

7. Install general KDE (Qt) applications from
   [apps-kde.list](packages/apps-kde.list).

8. Install general KDE (Qt) AUR applications from
   [apps-kde-aur.list](packages/apps-kde-aur.list).

9. Install GStreamer plugins for handing various media codecs.

10. Install container packages (conatinerd, LXC, Nomad, Podman).

11. Install packages for programming and software development.

12. Install AUR packages for programming and software development.

13. Install extra GTK applications from [extra.list](packages/extra.list).

14. Install extra KDE (Qt) applications from
    [extra-kde.list](packages/extra-kde.list).

15. Install game system emulators.

16. Install Virt-Manager and tools for using KVM virtualization.

17. Install packages for Linux guests to enable host-to-guest sharing and
    adjustable display resolution.

18. Install IRC, email, and other messaging clients.

19. Install MinGW for Windows/Linux cross-platform compilation.

20. Install applications for playing music (`mpd`, `ncmcpp`, `strawberry`),
    computing replaygain (`ffmpeg`), tagging metadata (`beets`), and using
    Pandora (`pianobar`).

21. Install CUPS, drivers, and applications for handling printers.

22. Install PipeWire for A/V handling (replaces PulseAudio, ALSA, etc.).

23. Install TeX libraries and Font Awesome icons.

24. Download and install the Tor browser. Edits the application launcher icon to
    look for "browser-tor".

25. Install `vim` and `vim-plugins` and then set the user vimrc.

26. Install `neovim` and `neovim-plugins` and then set the user init.vim.

27. Install LazyVim for Neovim and its dependencies.

28. Install VirtualBox and kernel modules (dkms) for running it (host).

29. Install kernel modules (dkms) and tools for VirtualBox guests.

30. Install Wine not-emulator, along with the Mono and browser and some audio
    libraries.

#### 8) Themes

```
1) Back                           8) Materia (KDE)
2) All                            9) Fonts
3) Arc (GTK)                     10) Papirus (icons)
4) Arc (KDE)                     11) Colorific themes
5) Adapta (GTK)                  12) Nightfox themes
6) Plata (GTK)                   13) Timed backgrounds
7) Materia (GTK)                 14) Dynamic wallpapers (Plasma)
```

3. Download, compile, and install a
   [fork](https://github.com/sudorook/arc-theme) of the
   [Arc GTK theme](https://github.com/horst3180/arc-theme).

4. Download, compile, and install a [fork](https://github.com/sudorook/arc-kde)
   of the
   [Arc Kvantum theme](https://github.com/PapirusDevelopmentTeam/arc-kde).

5. Download, compile, and install a
   [fork](https://github.com/sudorook/adapta-gtk-theme) of the
   [Adapta GTK theme](https://github.com/adapta-project/adapta-gtk-theme).

6. Download, compile, and install a
   [fork](https://gitlab.com/sudorook/plata-theme) of the
   [Plata GTK theme](https://gitlab.com/tista500/plata-theme).

7. Download, compile, and install a
   [fork](https://github.com/sudorook/materia-theme) of the
   [Materia GTK theme](https://github.com/nana-4/materia-theme).

8. Download, compile, and install a
   [fork](https://github.com/sudorook/materia-kde) of the
   [Materia Kvantum theme](https://github.com/PapirusDevelopmentTeam/materia-kde).

9. Install Noto, Cantarell, Ubuntu, Dejavu, and Roboto fonts.

10. Install tweaked version of Papirus icon theme.

11. Install [colorific themes](https://github.com/sudorook/colorific.vim) for
    alacritty, gitk, kitty, Neovim, tmux, and Vim.

12. Install [Nightfox themes](https://github.com/sudorook/nightfox.nvim) for
    alacritty, kitty, Neovim, and tmux.

13. Install [timed backgrounds](https://github.com/sudorook/timed-backgrounds)
    where transitions from day to night match sunrise/sunset times.

14. Install
    [timed backgrounds](https://github.com/sudorook/plasma5-timed-backgrounds)
    for Plasma where transitions from day to night match sunrise/sunset times.

#### 9) Personalization

```
 1) Back                            12) Hide Avahi programs
 2) All                             13) Import KDE settings
 3) Select system fonts             14) Import application dconf
 4) Select icon theme               15) Import GNOME terminal profiles
 5) Select GTK theme                16) Enable autologin
 6) Select Plasma theme             17) Invert brightness (i915)
 7) Select Plymouth theme           18) Enable IOMMU (Intel)
 8) Set dark GTK                    19) Disable PulseAudio suspend
 9) Select login shell              20) Disable 802.11n
10) Import Cinnamon dconf           21) Add scripts
11) Import GNOME dconf              22) Select default kernel
```

3. Select the system font. (Noto or Roboto)

4. Select the system icon theme.

5. Select the system desktop theme (GTK).

6. Select the system desktop theme (Plasma).

7. Select the Plymouth splash screen theme.

8. Set GTK applications to prefer the dark theme.

9. Select default login shell (Bash or Zsh).

10. Import pre-defined dconf settings for Cinnamon.

11. Import pre-defined dconf settings for GNOME.

12. Hide the Avahi desktop applications in the application list.

13. Configure default desktop and application settings for Plasma.

14. Import pre-defined dconf settings for applications.

15. Import GNOME-terminal profiles (Light/Dark) via dconf.

16. Enable autologin for the current user.

17. Invert brightness via kernel command line options in the GRUB prompt.

18. Enable Intel IOMMU for the i915 graphics driver. Helps fix blank displays
    for Haswell CPUs running kernels >=5.7.

19. Disable PulseAudio suspend (suspend can sometimes cause weird buzzing).

20. Disable 802.11n networking in iwlwifi. May help speed up poor 802.11ac
    connections.

21. Download and install
    [general utility scripts](https://github.com/sudorook/misc-scripts).

22. Select the default boot kernel from the currently installed ones.
