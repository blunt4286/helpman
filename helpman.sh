#!/bin/bash

function helpman() {
	local choice=""

	while true; do
		echo ""
		echo "----------------------"
		echo "HelpMan: Pacman Helper"
		echo "----------------------"
		echo ""
		echo "1 - See installed packages"
		echo "2 - Search installed packages"
		echo "3 - Remove orphaned packages"
		echo "4 - Update package database with yay"
		echo "5 - Update with yay"
		echo "6 - Search pacman"
		echo "7 - Search AUR with yay"
		echo "8 - Show details about a specified package"
		echo "9 - Backup current package list"
		echo "0 - Restore package list from backup"
		echo "q - Exit"
		echo "m - manual"
		echo ""
		
		read -p "Enter your selection: " choice
		
		echo "---------------------"
		
		if [[ $choice =~ ^[0-9mMqQ]$ ]]; then
			case $choice in
				1) 	
					clear;
					output=$(LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | LC_ALL=C sort -h)
					echo "$output"
					# Prompt for additional commands
					echo ""
					while true; do
						echo ""
						read -p "Enter command to pipe output (or leave empty to skip): " pipe_cmd
						echo ""
						if [ -z "$pipe_cmd" ]; then
							break  # Exit if input is empty
						else
							# Execute command if not empty
							eval "echo \"$output\" | $pipe_cmd"
						fi
					done;;
					
				2)
					clear;
					read -p "Enter package name: " search_term
					if [ -z "$search_term" ]; then
						echo "The package name, dumbass... "
					else
						echo "Searching for '$search_term'"
						echo ""
						output=$(LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | LC_ALL=C sort -h | grep "$search_term")
						if [ -z "$output" ]; then
							echo "No packages found matching '$search_term'"
						else
							echo "$output"
							# Prompt for additional commands
							while true; do
								echo ""
								read -p "Enter command to pipe output (or leave empty to skip): " pipe_cmd
								echo ""
								if [ -z "$pipe_cmd" ]; then
									break
								else
									eval "echo \"$output\" | $pipe_cmd"
								fi
							done
						fi
						echo ""
					fi;;

				3)
					clear;
					orphans=$(pacman -Qdtq)
					if [ -z "$orphans" ]; then
						echo "No orphaned packages found."
					else
						sudo pacman -Rns $orphans
					fi;;
					
				4) 
					clear;
					yay -Sy ;;
					
				5)
					clear;
					yay -Syu;;
					
				6)
					clear;
					read -p "Enter package name: " search_term
					if [ -z "$search_term" ]; then
						echo "The package name, dumbass... "
					else
						echo "Searching pacman for '$search_term'"
						pacman -Ss "$search_term"
					fi;;
					
				7)	
					clear;
					read -p "Enter package name: " search_term
					if [ -z "$search_term" ]; then
						echo "The package name, dumbass... "
					else
						echo "Searching AUR using yay for '$search_term'"
						yay -Ss "$search_term"
					fi;;
				
				8)
					clear;
    					read -p "Enter package name: " pkg_name
    					if [ -z "$pkg_name" ]; then
        					echo "The package name, dumbass... "
    					else
        					pacman -Qi "$pkg_name"
        					pacman -Qd "$pkg_name"  # Show package dependencies
    					fi;;
					
				9) 
					 clear;
    					 echo "Backing up installed package list..."
    					 pacman -Qq > ~/installed_packages_list.txt  # Backup list to a file
    					 echo "Backup saved to ~/installed_packages_list.txt"
    					 ;;
					
				0)
					clear;
					echo "Restoring package list..."
					sudo pacman -S --needed - < ~/installed_packages_list.txt  # Restore packages from backup
					echo "Packages restored."
					;;
				
				q) 
					echo ""
					echo "Exiting HelpMan."
					echo ""
					break;;
				
				m) 
					clear;
					echo "Helpman : Pacman Helper v1"
					echo ""
					echo "--------------------------------------------"
					echo "The exact commands used in this script are: "
					echo "--------------------------------------------"
					echo ""
					echo "Option 1:"
					echo "LC_ALL=C pacman -Qi | awk '/^Name/{name='$'3} /^Installed Size/{print '$'4'$'5, name}' | LC_ALL=C sort -h"
					echo ""
					echo "Option 2:"
					echo "LC_ALL=C pacman -Qi | awk '/^Name/{name='$'3} /^Installed Size/{print '$'4'$'5, name}' | LC_ALL=C sort -h | grep '{'yourSearchTerm'}'"
					echo ""
					echo "Option 3:"
					echo "pacman -Qdtq"
					echo "if orphaned packages are found, output is piped into:"
					echo "sudo pacman -Rns '{'orphans'}'"
					echo ""
					echo "Option 4:"
					echo "yay -Sy"
					echo ""
					echo "Option 5:"
					echo "yay -Syu"
					echo ""
					echo "Option 6:"
					echo "pacman -SS '{'searchTerm'}'"
					echo ""
					echo "Option 7:"
					echo "yay -Ss"
					echo ""
					echo "Option 8:"
					echo "pacman -Qq > ~/installed_packages_list.txt"
					echo ""
					echo "Option 9:"
					echo "sudo pacman -S --needed - < ~/installed_packages_list.txt"
					echo ""
					read -n 1 -s -p "Press any key to continue..." key
					clear
					;;
					
			esac
		else
			clear;
			echo "Invalid selection"
			read -n 1 -s -p "..." key
			echo ""
		fi
	done
}

helpman

