#!/bin/bash

# File containing username and password 
filename="credentials.txt"
echo $filename

ip_file="ip_list.txt"
echo $ip_file

output="aide_status.txt"
echo $output

user=$(head -1 $filename | sed 's/ *$//g' )
pass=$(tail -1 $filename | sed 's/ *$//g' )

echo $user
echo "######"
echo $pass
echo "######"

while read ip; do
  ip=$(echo $ip | sed 's/ *$//g' ) 
  echo "$ip"
  echo "tasks $ip"
  echo "$user:$pass"

  if sshpass -p "$pass" ssh -q -o StrictHostKeyChecking=no "$user"@"$ip" "aide --check" | grep -q "AIDE found differences"; then
    aide_status="Running"
  else
    aide_status="Not Running"  
  fi
    # Write to output  
  echo "$ip : $aide_status" >> $output

done <$ip_file
