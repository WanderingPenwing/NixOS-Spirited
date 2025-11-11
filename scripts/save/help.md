# Keybinds

## Tags

mod				    : view
mod+shift		    : tag
mod+ctrl		    : toggle view
mod+ctrl+shift      : toggle tag

## Layout

mod+space		    : toggle monocle
mod+f 			    : toggle fullscreen
mod+shift+h		    : increase stack width
mod+shift+l 	    : decrease stack width
mod+pg_up		    : increase master stack size
mod+pg_down 	    : decrease master stack size

## Movement

mod+j			    : focus window +1
mod+k			    : focus window -1
mod+shift+j 	    : move window +1
mod+shift+k 	    : move window -1
mod+m 			    : toggle master	
mod+comma		    : focus monitor -1
mod+comma		    : focus monitor +1
mod+shift+comma	    : move monitor -1
mod+shift+dot	    : move monitor +1	

## Spawn

mod+d			    : dmenu launcher
mod+return 		    : terminal
mod+i			    : browser
mod+n			    : notes
mod+t 			    : task manager
mod+slash		    : help
mod+r 			    : repos

## Functions

mod+shift+q 	    : kill window
mod+0			    : mute sound
mod+equal		    : increase volume
mod+minus		    : decrease volume
mod+] 			    : increase brightness
mod+[ 			    : decrease brightness
mod+u			    : usb
mod+p			    : hdmi paint
mod+s 			    : screen
mod+esc			    : screenshot
mod+v 			    : susuwatari paste
mod+b 			    : bookmark get
mod+shift+b 	    : bookmark add
mod+c 			    : calculator
mod+del			    : kill process

# keyboard move in kodama-st

shift+escape	    : initiate keyboard selection
h, j, k, l          : move cursor left/down/up/right (also with arrow keys)
!, _, *             : move cursor to the middle of the line/column/screen
backspace, $        : move cursor to the beginning/end of the line
pg_up, pg_down      : move cursor to the beginning/end of the column
home, end           : move cursor to the top/bottom left corner of the screen
/, ?                : activate input mode and search up/down
n, N                : repeat last search, up/down
s                   : toggle move/selection mode
t                   : toggle regular/rectangular selection type
return              : quit keyboard_select, keeping the highlight of the selection
escape              : quit keyboard_select
ctrl+shift+pg_up    : increase font size
ctrl+shift+pg_down  : decrease font size
