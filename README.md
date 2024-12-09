# mongodb-backup
Script to take mongodb backup automatically
# Script to take a backup of MongoDB for example Production or Staging or Stab or UAT environments

## Getting started

### Scope
Standardized way of taking MongoDB backups through a script reducing manual efforts of creating a database session by logging in and taking backups
### Reason
This is greatly beneficial for users for any activity that requires to take a backup without going inside database. 

## Usage

### prerequisites 
This is a bash script for linux (WSL) and to successfully run the script, the `mongodump` command (from mongodb-tools) must be installed  
### running the script
Clone the repo and run:
`mongo_backups/mongo_backups.sh`

## Troubleshooting
- check if mongodump is installed
- check if script has executable permissions
- check your db password
- check whether your ip is added under Network access list in MongoAtlas UI



