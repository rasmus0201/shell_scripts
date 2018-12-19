#!/bin/bash
# Script to add a user to linux system

#Get userID and check if 0 = root user
if [ $(id -u) -eq 0 ]; then

    #Check if file is given as argument, and exists
    if [ -e "$1" ]; then
        
        #Loop each line in file
        while IFS='' read -r line || [[ -n "$line" ]]; do
            IFS=: read -r username password <<< "$line" #split line by ":" and store vars
            
            #check if user exists
            grep -E "^$username" /etc/passwd >/dev/null 
            if [ $? -eq 0 ]; then
                echo "$username exists!"
            else
                #Add user if not exists, and set password
                useradd $username
                echo $password | passwd --stdin $username > /etc/null
                [ $? -eq 0 ] && echo "$username has been added to system!" || echo "Failed to add $username!"
            fi

        done < "$1"
        
    else
        #enter username
        read -p "Enter username: " username
        grep -E "^$username" /etc/passwd >/dev/null
        
        #check if user exists
        if [ $? -eq 0 ]; then
            echo "$username exists!"
            exit 1
        else
            #Read password and create user
            read -p "Enter password: " password
            useradd $username
            echo $password | passwd --stdin $username > /etc/null
            [ $? -eq 0 ] && echo "$username has been added to system!" || echo "Failed to add $username!"
        fi
    fi

    exit 1
    
else
    echo "Only root may add user(s) to the sytem!"
    exit 2
fi

