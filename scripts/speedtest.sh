#!/usr/bin/env bash

# Start time
start_time=$(date +%s)

# Run the speed test and capture the output
output=$(cfspeedtest -o json-pretty -m 1m)

# Extract and calculate the averages for download speeds
download_avgs=$(echo "$output" | grep -A 6 '"test_type": "Download"' | grep '"avg":' | sed 's/[",]//g' | awk '{print $2}')
download_sum=0
download_count=0

for avg in $download_avgs; do
  download_sum=$(echo "$download_sum + $avg" | bc)
  download_count=$((download_count + 1))
done

if [ $download_count -gt 0 ]; then
  average_download=$(echo "scale=10; $download_sum / $download_count" | bc)
else
  average_download=0
fi

# Extract and calculate the averages for upload speeds
upload_avgs=$(echo "$output" | grep -A 6 '"test_type": "Upload"' | grep '"avg":' | sed 's/[",]//g' | awk '{print $2}')
upload_sum=0
upload_count=0

for avg in $upload_avgs; do
  upload_sum=$(echo "$upload_sum + $avg" | bc)
  upload_count=$((upload_count + 1))
done

if [ $upload_count -gt 0 ]; then
  average_upload=$(echo "scale=10; $upload_sum / $upload_count" | bc)
else
  average_upload=0
fi

# End time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Display the results
echo "Average Download Speed: $average_download"
echo "Average Upload Speed: $average_upload"
echo "Script Execution Time: $elapsed_time seconds"
