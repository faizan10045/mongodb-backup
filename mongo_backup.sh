#!/bin/bash

# Function to prompt user for confirmation
confirm() {
    read -p "$1 (yes/no): " response
    case "$response" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

# Function to display available databases
display_databases() {
    echo "--------Available databases:"
    echo "$databases"
    echo
}

# Function to display main menu
display_menu() {
    echo "--------What would you like to do (type 1/2/3)?"
    echo "1. Switch to a database"
    echo "2. Take a backup of all databases"
    echo "3. Exit"
}

# Function to display collections
display_collections() {
    collections=$(mongosh "$connection_string$selected_db" --apiVersion 1 --norc --quiet --eval "db.getCollectionNames().join('\n')")
    echo "--------Available collections in $selected_db:"
    echo "$collections"
    echo
}

# Function to take backup of single collection or full database
take_backup() {
    local backup_type=$1
    local backup_target=$2
    local backup_file="backup_${backup_target}_$(date +'%Y_%m_%d')"
    local i=1
    while [ -e "$backup_file" ]; do
        backup_file="backup_${backup_target}_$(date +'%Y_%m_%d')_$i"
        ((i++))
    done
    mkdir -p "$backup_file"
    if [ "$backup_type" = "collection" ]; then
        mongodump --uri="$connection_string" --ssl --db "$selected_db" --collection "$backup_target" --out "$backup_file"
    elif [ "$backup_type" = "database" ]; then
        mongodump --uri="$connection_string" --ssl --db "$selected_db" --out "$backup_file"
    else
        mongodump --uri="$connection_string" --ssl --authenticationDatabase admin --out "$backup_file"
    fi
    echo "Backup completed for $backup_target"
    echo
}

# Function to URL-encode a string
urlencode() {
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
}

# Prompt user to select environment
echo "1. Staging 2. Production - type your response (1/2)"
read -e -p "Enter your choice: " env_choice

case "$env_choice" in
    1)
        # Staging environment- make sure to replace your connection string 
        read -s -p "Enter MongoDB password for staging: " password
        echo
        echo
        encoded_password=$(urlencode "$password")
        connection_string="mongodb+srv://example-staging:$encoded_password@staging.mongodb.net/"
        ;;
    2)
        # Production environment- make sure to replace your connection string
        read -s -p "Enter MongoDB password for production: " password
        echo
        echo
        encoded_password=$(urlencode "$password")
        connection_string="mongodb+srv://example-production:$encoded_password@prod.mongodb.net/"
        ;;
    *)
        echo "Invalid choice, exiting."
        exit 1
        ;;
esac

# Connect to MongoDB and authenticate
databases=$(mongosh "$connection_string" --apiVersion 1 --norc --quiet --eval "db.getMongo().getDBNames().join('\n')")

# Check if MongoDB connection was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to connect to MongoDB. Please check your credentials and try again."
    exit 1
fi

# List available databases
display_databases

while true; do
    # Display main menu
    display_menu

    # Prompt user for action selection
    read -e -p "Enter your choice: " action

    case "$action" in
        1)
            # Prompt user for database selection
            echo
            echo "--------Which database would you like to switch to?"
            read -e -p "" selected_db
            echo "Switched to database: $selected_db"
            echo

            # Prompt user to display collections
            while true; do
                echo "--------What would you like to do (type 1/2/3/4/5)?"
                echo "1. View collections"
                echo "2. Take a backup of single collection"
                echo "3. Take a backup of full $selected_db"
                echo "4. Back to main menu"
                echo "5. Exit"
                read -e -p "Enter your choice: " inner_action

                case "$inner_action" in
                    1)
                        # Display collections
                        display_collections
                        ;;
                    2)
                        read -e -p "Enter the collection name you want to take a backup of: " collection_name
                        # Validate input to avoid command injection
                        if [[ $collection_name =~ ^[a-zA-Z0-9_]+$ ]]; then
                            echo "--------Taking backup of single collection: $collection_name ..."
                            take_backup "collection" "$collection_name"
                        else
                            echo "Invalid collection name."
                        fi
                        ;;
                    3)
                        echo "--------Taking backup of full $selected_db ..."
                        take_backup "database" "$selected_db"
                        ;;
                    4)
                        break
                        ;;
                    5)
                        echo "--------Exiting script"
                        exit 0
                        ;;
                    *)
                        echo "Invalid choice, try again."
                        ;;
                esac
            done
            ;;
        2)
            echo "--------Taking backup of all databases..."
            take_backup "all_databases"
            ;;
        3)
            echo "--------Exiting script"
            exit 0
            ;;
        *)
            echo "Invalid choice, try again."
            ;;
    esac
done
