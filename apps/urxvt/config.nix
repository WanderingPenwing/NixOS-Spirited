{
  config,
  pkgs,
  ...
}: {
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
      #define nord0 #222222
      #define nord1 #FF5555
      #define nord2 #5FD38D
      #define nord3 #FF9955
      #define nord4 #3771C8
      #define nord5 #BC5FD3
      #define nord6 #5FD3BC
      #define nord7 #999999
      #define nord8 #666666
      #define nord9 #FF8080
      #define nord10 #87DEAA
      #define nord11 #FFB380
      #define nord12 #5F8DD3
      #define nord13 #CD87DE
      #define nord14 #87DECD
      #define nord15 #CCCCCC

      *.foreground:   nord15
      *.background:   nord0
      *.cursorColor:  nord15
      *fading: 20
      *fadeColor: nord0

      *.color0: nord0
      *.color1: nord1
      *.color2: nord2
      *.color3: nord3
      *.color4: nord4
      *.color5: nord5
      *.color6: nord6
      *.color7: nord7
      *.color8: nord8
      *.color9: nord9
      *.color10: nord10
      *.color11: nord11
      *.color12: nord12
      *.color13: nord13
      *.color14: nord14
      *.color15: nord15

      ! URxvt Settings DejaVu Sans Mono
      URxvt.font:     xft:Hurmit Nerd Font:size=13:antialias=true
      URxvt.boldFont: xft:Hurmit Nerd Font:bold:size=13:antialias=true
      urxvt*scrollBar:                  false
      urxvt*mouseWheelScrollPage:       true
      urxvt*cursorBlink:                true
      urxvt*saveLines:                  5000
      urxvt*internalBorder: 15
      urxvt*geometry: 90x90
      ! Setting transparency and background
       URxvt*depth:      32
       URxvt.background: [70]#222222

      ! Normal copy-paste keybindings  ( ctrl-shift c/v )
      urxvt.iso14755:                   false
      urxvt.keysym.Shift-Control-V:     eval:paste_clipboard
      urxvt.keysym.Shift-Control-C:     eval:selection_to_clipboard
      !xterm escape codes, word by word movement
      urxvt.keysym.Control-Left:        \033[1;5D
      urxvt.keysym.Shift-Control-Left:  \033[1;6D
      urxvt.keysym.Control-Right:       \033[1;5C
      urxvt.keysym.Shift-Control-Right: \033[1;6C
      urxvt.keysym.Control-Up:          \033[1;5A
      urxvt.keysym.Shift-Control-Up:    \033[1;6A
      urxvt.keysym.Control-Down:        \033[1;5B
      urxvt.keysym.Shift-Control-Down:  \033[1;6B
    ''}
  '';
}
