#!/bin/bash

# File containing username and password 
cred_file=credentials.txt

# File containing IP addresses
ip_file=ip_list.txt

# Output file
output=aide_status.txt 

# Read credentials line by line
while read user pass; do

  # Read IP addresses 
  while read ip; do

    # SSH login
    sshpass -p "$pass" ssh -q -o StrictHostKeyChecking=no "$user"@"$ip" exit

    # Check AIDE status
    if sshpass -p "$pass" ssh -q -o StrictHostKeyChecking=no "$user"@"$ip" "aide --check" | grep -q "AIDE found differences"; then
      aide_status="Running"
    else
      aide_status="Not Running"  
    fi

    # Write to output  
    echo "$ip $aide_status" >> "$output"

  done < "$ip_file"

done < "$cred_file"
