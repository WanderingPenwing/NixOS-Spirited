movie=$(ls | awk 'BEGIN{print "cancel"} {print $0}' | marukuru -l 15) 

if [ "$movie" = "cancel" ]; then
	exit 1
fi

if [[ -d "$PWD/$movie" ]]; then
	for f in "$PWD/$movie"/*
	do
		sudo scp -i ~/.ssh/github "$f" bathhouse@penwing.org:/home/bathhouse/transfer
	done
    
elif [[ -f "$PWD/$movie" ]]; then
	sudo scp -i ~/.ssh/github "$PWD/$movie" bathhouse@penwing.org:/home/bathhouse/transfer
else
    echo "$PWD/$movie is not valid"
    exit 1
fi
