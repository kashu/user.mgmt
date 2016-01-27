#!/bin/bash
#Author: kashu
#My Website: https://kashu.org
#Date: 2013-05
#Filename: user.mgmt.sh
#Description: Create/Delete a batch of accounts.(For RHEL/CentOS)

read -p "Enter [a|A] to add users or Enter [d|D] to delete users: " opt
if [ "${opt}" == "a" -o "${opt}" == "A" ]; then
	#read -p "enter your user list file location: " userlist
	userlist=./Ausers.lst
	if [ -f "${userlist}" ]; then
		for user in `egrep -v ^'(#|$)' ${userlist} | cut -d: -f1`; do
			E=`cut -d: -f1 < /etc/passwd | grep ${user}`
			if [ "${E}" == "" ]; then
				for pass in `grep ${user} ${userlist} | cut -d: -f2`; do
					useradd ${user} && echo ${pass} | passwd --stdin ${user} && chage -d 0 "`echo ${user}`" \
					&& echo "Create [${user}] Successfully!" || echo "Create [${user}] ERROR!!"
				done
			else
				echo "[${user}] is already EXISTS!" && continue
			fi
		done
	else
		echo "The file ${userlist} doesn't exist!"
	fi
elif [ "${opt}" == "d" -o "${opt}" == "D" ]; then
	#read -p "enter your user list file location: " userlist
	userlist=./Dusers.lst
	if [ -f "${userlist}" ]; then
		for user in `egrep -v ^'(#|$)' ${userlist} | cut -d: -f1`; do
			E=`cut -d: -f1 < /etc/passwd | grep ${user}`
			if [ "${E}" == "${user}" ]; then
				userdel -r ${user} && echo "Delete [$user] successfully" || echo "Delete [$user] ERROR!!"
			else
				echo "[${user}] doesn't EXIST!!" && continue
			fi
		done
	else
		echo "The file ${userlist} doesn't exist!"
	fi
else
	echo -e "\nUsage:\nenter 'a' or 'A' to add users from a specific user list file;\
	\nenter 'd' or 'D' to delete users from a specific user list file." && exit
fi
