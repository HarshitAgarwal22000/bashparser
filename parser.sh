#!/bin/bash
log_file="C:\Users\harsh\OneDrive\Desktop\access.log"
todas=$(grep "$(date +'%Y/%b/%d')" "$log_file")
highhost=$(awk -F ' ' '{print $13}' "$log_file"|sort|uniq -c|sort -nr|head -n 1)
totalstatus_code=$(awk -F ' ' '{print $6}' "$log_file"|sort|uniq -c)
#printing today stuff
echo "Today"
echo "$todas"
echo " highest req host"

echo "$highhost"
echo "requests per status code"
echo "$totalstatus_code"
#printed all codes
top_upstream_ip=$(awk -F ' ' '{print $8}' "$log_file" | sort | uniq -c | sort -nr | head -n 5)
top_requests_by_host=$(awk -F ' ' '{print $13}' "$log_file" |sort| uniq -c | sort -nr | head -n 5)
top_requests_by_body_bytes_sent=$(awk -F ' ' '{print $9}' "$log_file" | sort -n | tail -n 5)
top_requests_by_path=$(awk -F ' ' '{print $4}' "$log_file" | cut -d '/' -f 1,2 | sort | uniq -c | sort -nr | head -n 5)
top_requests_by_response_time=$(awk -F ' ' '{print $7}' "$log_file" | sort -n | tail -n 5)

top_5xx_requests_per_host=$(awk -F ' ' '$6 ~ /^5[0-9][0-9]$/{print $13}' "$log_file" | sort | uniq -c | sort -nr | head -n 5)
requests_within_10_minutes=$(awk -F ' ' -v threshold="$time_threshold" '$2 > threshold{print}' "$log_file")
echo "$top_upstream_ip"

echo "$top_requests_by_host"
echo ""

echo "$top_requests_by_body_bytes_sent"
echo ""

echo "$top_requests_by_path"
echo ""
echo "$top_requests_by_response_time"
echo ""
echo "$top_5xx_requests_per_host"
echo "$requests_within_10_minutes"

