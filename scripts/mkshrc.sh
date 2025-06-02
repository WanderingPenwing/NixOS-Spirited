PS1=$'\n\e[34m`hostname` \e[35m${IN_NIX_SHELL:+(nix) }\e[36m\$(pwd | sed "s|^$HOME|~|; s|\(.*\)/[^/]*$|\1/.../|")\n\e[32m>\e[0m '

alias m="nvim"
alias v="nvim"
alias c="clear"
alias nsp="nix-shell -p --command 'mksh'"
alias nsh="nix-search -r"
alias rebuild="sh -c '$HOME/nixos/scripts/rebuild.sh'"
alias edit="sh -c '$HOME/nixos/scripts/edit.sh'"
alias scrub="sh -c '$HOME/nixos/scripts/scrub.sh'"
alias ct="sh -c '$HOME/nixos/scripts/clone_terminal.sh'"
alias bd="btm -C '$HOME/nixos/apps/bottom/debug.toml'"
alias bf="btm -C '$HOME/nixos/apps/bottom/full.toml'"
alias ls='ls --color=auto'
alias help='less ~/nixos/scripts/save/help.md'
alias weather="curl wttr.in"
alias mkrc="$EDITOR '$HOME/nixos/scripts/mkshrc.sh"
alias du='dust'
alias ys="yazi ~/nixos/scripts"
alias manf="man -k . | fzf | awk '{print $1}' | xargs -r man"

HISTFILE="$HOME/.ksh_history"
HISTSIZE=5000

fzf_history_search() {
  local selected_cmd
  selected_cmd=$(fc -l -n 1 | sed 's/^[[:space:]]*//' | awk '!seen[$0]++' | fzf --height=10 --reverse --prompt="Search History> " --tac)
  if [ -n "$selected_cmd" ]; then
    print "$selected_cmd"
  fi
}

fzf_file_search() {
  local selected_file
  selected_file=$(ls | fzf --height=10 --reverse --prompt="Select> ")
  if [ -n "$selected_file" ]; then
    echo -n "'$selected_file'"
  fi
}

fzf_autocomplete() {
  local current_input escaped_input command_list selected_cmd path command_end escaped_command_end prefix
  escape_special_chars() {
    printf '%s' "$1" | sed -e 's/[]\/$*.^[]/\\&/g'
  }

  # Load current input
  current_input=$(cat ~/.auto_complete 2>/dev/null)
  [ -z "$current_input" ] && return 1  # Exit if no input is available
  escaped_input=$(escape_special_chars "$current_input")

  # Handle directory paths (if input ends with '/')
  if [[ "$current_input" == */ ]]; then
    path=$(echo -e "$current_input" | rev | cut -d' ' -f1 | rev)
	command_list=$(ls -pw1 "$path" 2>/dev/null ) # List files in the directory
    if [ "$(echo -e "$command_list" | wc -l)" -eq 1 ]; then
      print "$current_input$command_list"
      return
    fi
    selected_cmd=$(printf "%s\n" "$command_list" | fzf --height=10 --reverse --prompt="> $current_input" --query="" -e --bind='tab:down,space:accept')
    print "${current_input}${selected_cmd:-}"
    return
  fi

  # Generate command list from history
  #raw_list="$(ls -1 /run/current-system/sw/bin)\n$(fc -l -n 1)"
  command_list=$(fc -l -n 1 | sed 's/^[[:space:]]*//' | awk '!seen[$0]++' | grep "^$current_input" | grep -v "^$current_input$" | sed "s/^$escaped_input//")
  # Extract common prefix
  prefix=$(printf "%s\n" "$command_list" | sed -e '1{h;d;}' -e 'G;s,^\(.*\).*\n\1.*,\1,;h;$!d')

  # Handle new term or incomplete term
  if [[ "$prefix" == ' '* ]]; then
    current_input+=" "
    command_list=$(printf "%s\n" "$command_list" | sed "s/^ //")
  else
    command_end=$(echo -e "$current_input" | rev | cut -d' ' -f1 | rev)
    escaped_command_end=$(escape_special_chars "$command_end")
    command_list=$(printf "%s\n" "$command_list" | grep -v '[./]') # removes pathes in history

    # Separate history and ls
    if [[ -n "$command_list" ]]; then
    	command_list+=$'\n'
    fi
    
    path="."
    # Update the end if we want to continue a path
    if [[ "$command_end" == *\/* ]]; then
	  path=$(dirname "$command_end")
	  command_end=$(basename "$command_end")
	  escaped_path=$(escape_special_chars "$path")
	  escaped_command_end=$(escape_special_chars "$command_end")
    fi
    # Handle hidden files
    if [[ "$command_end" == '.' ]]; then
      command_list+=$(ls -paw1 $path | grep "^\." | sed 's/^\.\(.*\)$/\1/' )
    elif [[ "$command_end" == '.'* ]]; then
      command_list+=$(ls -paw1 $path | grep "^$escaped_command_end" | sed "s/^$escaped_command_end//")
    else
      command_list+=$(ls -pw1 $path | grep "^$command_end" | sed "s/^$escaped_command_end//")
    fi
  fi
  
  # Sort and deduplicate command list
  command_list=$(printf "%s\n" "$command_list" | cut -d' ' -f1 | awk '!seen[$0]++' | sed '/^$/d' | awk '{ print length, $0 }' | sort -n | cut -d' ' -f2-)

  # Add the common part to the current input and remove it from the items
  prefix=$(printf "%s\n" "$command_list" | sed -e '1{h;d;}' -e 'G;s,^\(.*\).*\n\1.*,\1,;h;$!d')
  escaped_prefix=$(escape_special_chars "$command_prefix")
  current_input+="$prefix"
  command_list=$(printf "%s\n" "$command_list" | sed "s/^$prefix//" | sed '/^$/d' )

  # If there is nothing to complete
  if [[ -z "$command_list" ]]; then 
  	print "$current_input"
  	return
  fi
  selected_cmd=""
  
  # Autocomplete for single match or multi match
  if [ "$(echo -e "$command_list" | wc -l)" -eq 1 ]; then
  	selected_cmd="$command_list"
  else
    selected_cmd=$(printf "%s\n" "$command_list" | fzf --height=10 --reverse --prompt="> $current_input" --query="" -e --bind='tab:down,space:accept')
  fi

  # append space to command if not a path "/"
  space=" " 
  if [[ "$selected_cmd" == */ ]]; then
 		space=""
 	fi
 	
  # Print the final result
  print "${current_input}${selected_cmd:-}"
}

copy_to_clipboard() {
  local cmd
  cmd=$(fc -l -n 1 | sed 's/^[[:space:]]*//' | fzf --height=10 --reverse --prompt="Select command> " --tac)
  if [ -n "$cmd" ]; then
    echo -n "$cmd" | xclip -selection clipboard
  fi
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

copy() {
  # Pipe the output to xclip and copy it to the clipboard
  tee /dev/tty | xclip -selection clipboard
}

hclean() {
	selected=$(fc -l -n 1 | sed 's/^[[:space:]]*//' | awk '!seen[$0]++' | fzf --reverse --prompt="Select entry> " --tac | sed 's/[][\\/.*^$(){}+?|]/\\&/g')
	echo "#$selected#"
	if [[ -n "$selected" ]]; then
		echo "s/.....$selected.//g"
	    #sed -i "s/.....$selected.//g" "$HISTFILE"
	else
		echo "cancelled"
	fi
}

if [ -d .git ]; then
    onefetch
fi

if [[ $- == *i* ]]; then
	bind -m '^r'='^ufzf_history_search^e'
	bind -m '^t= fzf_file_search^e'
	bind -m '^y'='^ucopy_to_clipboard^e'
	bind -m '^I= > ~/.auto_complete;^aecho  ^efzf_autocomplete^e'
fi
