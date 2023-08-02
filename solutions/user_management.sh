usage()
{
printf "Usage: $0 [OPTIONS]\n"
printf "Options:\n"
printf "  -c, --create     Create a new user account\n"
printf "  -d, --delete     Delete an existing user account\n"
printf "  -r, --reset      Reset the password of an existing user account\n"
printf "  -m, --modify     Modify User info\n"
printf "  -l, --list       List all user accounts\n"
printf "  -h, --help       Display this help message\n"
}
 
create_user()
{
read -p "Enter username: " username
if id "$username" &>/dev/null;then
printf "\nUser with '$username' already exists."
exit 1
fi
sudo useradd -m -s /bin/bash "$username" &>/dev/null
read -s -p "Enter password for '$username': " password
echo "$username:$password" | sudo chpasswd
printf "\nUser'$username'created successfully!"
}
 
reset_pass()
{
read -p "Enter username for changing password: " reset_user
if !id "reset_user" &> /dev/null;then
printf "\n'$reset_user' doesn't exist. "
exit 1
fi
read -sp "Enter new password for '$reset_user': " new_password
echo "$reset_user:new_password" | sudo chpasswd
printf "\nPassword for '$resest_user' successfully changed!"
 
}
 
delete_user()
{
read -p "Enter username of user to be deleted: " del_user
if ! id "$del_user" &> /dev/null;then
printf "\n '$del_user' doesn't exist."
exit 1
fi
 
sudo userdel -r "$del_user"
printf "\nUser '$del_user' has been deleted."
}
 
list() {
    echo "List of user accounts with detailed information:"
    while IFS=':' read -r username _ uid gid info home shell; do
        echo "Username: $username"
        echo "UID: $uid"
        echo "GID: $gid"
        echo "Full Name: $info"
        echo "Home Directory: $home"
        echo "Shell: $shell"
        printf "\n"
    done < /etc/passwd
}
modify_account() {
    username="$1"
 
    # Check if username exists
    if ! id "$username" &>/dev/null; then
        echo "Error: Username '$username' does not exist."
        exit 1
    fi
 
    echo "Modify user account properties for '$username':"
    read -p "New username (leave empty to keep '$username'): " new_username
 
    if [ -n "$new_username" ] && [ "$new_username" != "$username" ]; then
        sudo usermod -l "$new_username" "$username"
        echo "Username updated to '$new_username'."
        username="$new_username"
    fi
 
    read -p "New home directory (leave empty to keep current home): " new_home
    if [ -n "$new_home" ]; then
        sudo usermod -d "$new_home" "$username"
        echo "Home directory updated to '$new_home'."
    fi
 
    read -p "New shell (leave empty to keep current shell): " new_shell
    if [ -n "$new_shell" ]; then
            sudo usermod -s "$new_shell" "$username"
        echo "Shell updated to '$new_shell'."
    fi
 
    echo "User account '$username' properties updated."
user_info=$(getent passwd "$username")
echo "$user_info"
}
if [ $# -eq 0 ]; then
    usage
    exit 1
fi
 
case "$1" in
    -c|--create)
        create_user
        ;;
    -d|--delete)
        delete_user
        ;;
    -r|--reset)
        reset_pass
        ;;
    -l|--list)
    list
        ;;
 
    -m|--modify)
        if [ -z "$2" ]; then
            echo "Error: Username not provided for modify option."
            usage
            exit 1
        fi
        modify_account "$2"
        ;;
    -h|--help)
        usage
        ;;
     *)
        echo "Invalid option: $1"
        usage
        exit 1
        ;;
   esac
 
exit 0
