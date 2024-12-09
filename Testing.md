## Test Scope:
- User interaction & menu navigation
- MongoDB connection & authentication
- Database listing
-	Single collection backup
-	Full database backup (needs implementation)
-	Input validation (password, collection name)
-	Error handling (wrong credentials, invalid input)

## Test Cases:

<dl>
<dt>User Interaction:</dt>
<dd>Test successful navigation through all menus (switch database, backup options, exit).</dd>
<dd>Test handling of invalid menu choices (entering characters other than 1-3).</dd>
<dt>MongoDB Connection & Authentication:</dt>
<dd>Test successful connection with valid credentials.</dd>
<dd>Test failed connection with invalid credentials (intentionally provide wrong password).</dd>
<dt>Database Listing:</dt>
<dd>Verify that all available databases are displayed after successful connection.</dt>
<dt>Single Collection Backup:</dt>
<dd>Test successful backup of a single collection.</dd>
<dd>Test handling of non-existent collections.</dd>
<dd>Test input validation for collection names (avoid special characters or spaces).</dd>
<dt>Full Database Backup (Needs Implementation):</dt>
<dd>Test successful backup of the entire selected database.</dd>
<dd>Verify the completeness of the backup by comparing the backup size with the original database size (requires additional testing).</dd>
<dt>Error Handling:</dt>
<dd>Verify informative error message when encountering invalid credentials.</dd>
<dd>Verify informative message for non-existent collections during single collection backup.</dd>
</dl>

## Additional Considerations:
- Test script execution with different user permissions (if applicable).
- Consider testing on a staging MongoDB instance to avoid impacting production data.
- Dropped contract db from Test Schema and restored it.

## Before DROP

```go
db.getCollection("your_collection_name").find({}) /*all values*/
db.getCollection("your_collection_name").count() /* count of all values */
db.getCollection("your_collection_name").find({}).limit(10) /* first 10 values */
db.getCollection("your_collection_name").find({}).sort({ _id: -1 }).skip(Math.max(0, db.getCollection("your_collection_name").count() - 10)) /* last 10 values */
```

### Backup of a single collection inside test db
```bash
mongodump --uri="mongodb+srv://your_connection_string.mongodb.net/" --ssl --username <example-admin> --authenticationDatabase <example-admin> --db test --collection <example-your_collection_name> --out <example-backup_file_name>
```

### Backup of a single database with all collections
```bash
mongodump --uri="mongodb+srv://your_connection_string.mongodb.net/" --ssl --username <example-admin> --authenticationDatabase <example-admin> --db test --out <example-backup_file_name>
```
### Backup of full database
```bash
mongodump --uri="mongodb+srv://your_connection_string.net/" --ssl --username <example-admin> --authenticationDatabase <example-admin>  --out <example-backup_file_name>
```

### After DROP & RESTORE

```bash
mongorestore --uri="mongodb+srv://your_connection_string.net/" --ssl --username <example-admin> --authenticationDatabase <example-admin> --db test <example-your_collection_name> <example-backup_file_name>.bson --drop
```

### Verification
Run all the commands again and compare the results to understand the difference in data
