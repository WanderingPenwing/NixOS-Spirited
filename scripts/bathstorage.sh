movie=$(ls | awk 'BEGIN{print "cancel"} {print $0}' | dmenu -l 20 -fn 'Hack Regular-12' -nb "#222222" -nf "#CCCCCC" -sb "#3FB36D" -sf "#FFFFFF") 

if [ "$movie" = "cancel" ]; then
	exit 1
fi

if [[ -d "$PWD/$movie" ]]; then
	for f in "$PWD/$movie"/*
	do
		sudo scp -i ~/.ssh/github "$f" bathhouse@penwing.org:/home/bathhouse/downloads/
	done
    
elif [[ -f "$PWD/$movie" ]]; then
	sudo scp -i ~/.ssh/github "$PWD/$movie" bathhouse@penwing.org:/home/bathhouse/downloads/
else
    echo "$PWD/$movie is not valid"
    exit 1
fi
