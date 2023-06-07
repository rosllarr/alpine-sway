## Goal
- Pure Wayland with Sway as Window Manager
- Use Neovim as Text Editor
- GUI Apps running via Flatpak
- Use Fish as Interactive Shell and ash as Default Shell
- Manage Wireless network via iwd
- Use doas instead of sudo


## Setup phrese after first boot
> **_Remark:_** Following commands run in console as Root!

### Setting up a new user
- install doas
```bash
apk add doas

cat<<EOF > /etc/doas.d/doas.conf
permit persist :wheel

EOF
```

- create user
```bash
adduser tie
addgroup tie wheel
```

### Connect WiFi with iwd
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Wi-Fi#iwd

- stop wpa_supplicant
```bash
rc-service wpa_supplicant stop
```

- TODO: add step to setup iwd

- remove wpa_supplicant
```bash
apk del wpa_supplicant
```

### Install man pages
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#Why_don.27t_I_have_man_pages_or_where_is_the_.27man.27_command.3F

```bash
apk add mandoc man-pages mandoc-apropos
```

### Install video driver

- for Intel


- for AMD
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Radeon_Video


## Install Desktop environment
> **_Remark:_** Re-Login as tie before execute following commands

### Install sway
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Sway#Installation
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Intel_Video

- install and enable eudev
```bash
doas apk update
doas apk add eudev
doas setup-devd udev
```

- install intel video
```bash
doas apk add mesa-dri-gallium mesa-va-gallium intel-media-driver
```

- set XDG_RUNTIME_DIR
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Wayland#XDG_RUNTIME_DIR
```bash
cat<<EOF > ~/.profile
if test -z "${XDG_RUNTIME_DIR}"; then
  export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
  if ! test -d "${XDG_RUNTIME_DIR}"; then
    mkdir "${XDG_RUNTIME_DIR}"
    chmod 0700 "${XDG_RUNTIME_DIR}"
  fi
fi

EOF
```
> **_Remark:_** Re-Login as tie again!

- install sway
```bash
doas apk add font-dejavu
doas apk add seatd
doas rc-update add seatd
doas rc-service seatd start
doas addgroup sodface audio
doas addgroup sodface input
doas addgroup sodface seat
doas addgroup sodface video
doas apk add sway sway-doc foot bemenu swaylock swaylockd swaybg swayidle fish wl-clipboard

echo "dbus-run-session -- sway" >> ~/.profile
echo "" >> ~/.profile
```
> **_Remark:_** Re-Login as tie, now sway will auto start


### Alpine packages install
```bash
# helix is text editor
# fish is fish shell
doas apk add git docker docker-cli-compose curl chromium
```

### Install oh-my-fish and bang-bang package
> **_Ref:_** https://github.com/oh-my-fish/oh-my-fish#installation
> **_Ref:_** https://github.com/oh-my-fish/plugin-bang-bang#install

```bash
# install oh-my-fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

### install bang-bang package
omf install bang-bang
```

### Display Thai font in browser
> **_Ref:_** https://wiki.alpinelinux.org/wiki/Fonts

1. Install font packges
```bash
doas apk add font-noto font-noto-extra font-noto-thai
```

2. Set Noto-font for Chromium/Chrome
- https://support.google.com/chrome/answer/96810?hl=en&co=GENIE.Platform%3DDesktop


### Install helix
- install helix
```bash
doas apk add helix
```

- install requirement packages for python syntax highlight
```bash
doas apk add python3 tree-sitter-python py3-lsp-server
```