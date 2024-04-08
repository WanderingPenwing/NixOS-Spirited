#! /usr/bin/env bash

# Specify the folder path
input_path="./avatar_source/"
output_path="./avatar_output/"

# Count the number of files in the folder
num_files=$(ls -1 "$input_path" | wc -l)


# Loop through the files in the folder
for ((i=0; i<num_files; i+=2)); do

    vf_file=$(ls -1 "$input_path" | sed -n "$((i+1))p")
    vo_file=$(ls -1 "$input_path" | sed -n "$((i+2))p")

    ffmpeg -i "$input_path$vf_file" -i "$input_path$vo_file" -map 0 -map 1 -c copy "$output_path$vf_file" > /dev/null 2>&1
    echo -ne "$((i+2)) / $num_files"\\r
done


