SCRIPT_DIR=$(dirname "$0")

# File to store clipboard history
history_file="/home/penwing/nixos/scripts/susuwatari/history.txt"
separator="###SEPARATOR###"

rm -f "$history_file"
touch "$history_file"

echo "initialized"
echo "hello there" | xclip -selection clipboard -i

echo "$separator" >> "$history_file"

while true; do
    sleep 2
    
    clipboard_content=$(xclip -selection clipboard -o)
    
	entry=$(printf "%s" "$clipboard_content" | tr -d '\n')
	
	file_content=$(cat "$history_file" | tr -d '\n')
	
	if echo "$file_content" | grep -qF "$separator$entry$separator"; then
	    continue
	fi
	
    # Append clipboard content to history file
    echo "$clipboard_content" >> "$history_file"
    echo "$separator" >> "$history_file"
done
