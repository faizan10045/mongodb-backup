# mongodb-backup
## Script to take a backup of MongoDB automatimcally for environments like Production or Staging or Stab or UAT

## Getting started

### Scope
Standardized way of taking MongoDB backups through a script reducing manual efforts of creating a database session by logging in and taking backups
### Reason
This is greatly beneficial for users for any activity that requires to take a backup without going inside database. 

### Idea
The idea behind this script is to take backup of single collection or full collection or full database backup without writing any commands. We are doing it here in the script for 2 environments like Staging and Production environment. Just modify the script to include more environments. Furthermore, a test document is included to give you an idea on the type of testing performed on this script and how validation of data is performed.

## Usage

### prerequisites 
This is a bash script for linux (WSL) and to successfully run the script, the `mongodump` command (from mongodb-tools) must be installed  
### running the script
- Clone the repo
- make changes in the script mongo_backups.sh file to replace the connection strings 
- Use the below command to run:
`./mongo_backups.sh`


## Troubleshooting
- check if mongodump is installed
- check if script has executable permissions
- check your db password
- check whether your ip is added under Network access list in MongoAtlas UI



