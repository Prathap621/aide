#!/bin/bash

# File containing username and password 
cred_file="credentials.txt"
echo $cred_file

ip_file="ip_list.txt"
echo $ip_file

output="aide_status.txt"
echo $output

user=$(head -1 $cred_file | sed 's/ *$//g' )
pass=$(tail -1 $cred_file | sed 's/ *$//g' )

while read ip; do
  ip=$(echo $ip | sed 's/ *$//g' ) 

  if sshpass -p "$pass" ssh -q -o StrictHostKeyChecking=no "$user"@"$ip" "aide --check" | grep -q "AIDE found differences"; then
    aide_status="Running"
  else
    aide_status="Not Running"  
  fi
    # Write to output  
  echo "$ip : $aide_status" >> $output

done <$ip_file
