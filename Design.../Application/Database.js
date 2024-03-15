// Database.js
// Define a function to initialize the database
function dbInit() {
    // Open or create the database
    let db = LocalStorage.openDatabaseSync("Book_Tracker_DB", "", "Track books", 1000000)
    try {
        db.transaction(function (tx) {
            // Create a new table if it doesn't exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS book_log (bookTitle TEXT, author TEXT, genre TEXT, rating TEXT, comment TEXT)')
        })
    } catch (err) {
        // Handle errors if any occur during table creation
        console.log("Error creating table in the database: " + err)
    }
}

// Define a function to get a handle to the database
function dbGetHandle() {
    try {
        // Open the database and return the handle
        var db = LocalStorage.openDatabaseSync("Book_Tracker_DB", "", "Track books", 1000000)
    } catch (err) {
        // Handle errors if any occur during database opening
        console.log("Error opening the database: " + err)
    }
    return db
}

// Define a function to insert a new record into the database
function dbInsert(PbookTitle, Pauthor, Pgenre, Prating, Pcomment) {
    // Insert a new record into the database
    let db = dbGetHandle()
    let rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO book_log (bookTitle, author, genre, rating, comment) VALUES (?, ?, ?, ?, ?)',
                      [PbookTitle, Pauthor, Pgenre, Prating, Pcomment])
        let result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

// Define a function to read all records from the database
function dbReadAll(listModel) {
    // Read all records from the database and populate the model
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
            'SELECT rowid,bookTitle,author,genre,rating,comment FROM book_log ORDER BY rowid DESC')
        for (let i = 0; i < results.rows.length; i++) {
            listModel.append({
                id: results.rows.item(i).rowid,
                checked: " ",
                bookTitle: results.rows.item(i).bookTitle,
                author: results.rows.item(i).author,
                genre: results.rows.item(i).genre,
                rating: results.rows.item(i).rating,
                comment: results.rows.item(i).comment
            })
        }
    })
}

// Define a function to update an existing record in the database
function dbUpdate(PbookTitle, Pauthor, Pgenre, Prating, Pcomment, Prowid) {
    // Update an existing record in the database
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql(
            'UPDATE book_log SET bookTitle=?, author=?, genre=?, rating=?, comment=? WHERE rowid = ?', [PbookTitle, Pauthor, Pgenre, Prating, Pcomment, Prowid])
    })
}

// Define a function to delete a record from the database
function dbDeleteRow(Prowid) {
    // Delete a record from the database
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('DELETE FROM book_log WHERE rowid = ?', [Prowid])
    })
}

// Add this function to your Database.js
// Define a function to save the model data to the database
function dbSaveModel(model) {
    // Clear the existing entries in the database
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('DELETE FROM book_log')
    })

    // Insert all entries from the model into the database
    for (let i = 0; i < model.count; ++i) {
        dbInsert(
            model.get(i).bookTitle,
            model.get(i).author,
            model.get(i).genre,
            model.get(i).rating,
            model.get(i).comment
        )
    }
}
