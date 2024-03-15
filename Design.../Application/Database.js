// Database.js

function dbInit() {
    let db = LocalStorage.openDatabaseSync("Book_Tracker_DB", "", "Track books", 1000000)
    try {
        db.transaction(function (tx) {
            // Create a new table if it doesn't exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS book_log (bookTitle TEXT, author TEXT, genre TEXT, rating TEXT)')
        })
    } catch (err) {
        console.log("Error creating table in the database: " + err)
    }
}


function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("Book_Tracker_DB", "", "Track books", 1000000)
    } catch (err) {
        console.log("Error opening the database: " + err)
    }
    return db
}

function dbInsert(PbookTitle, Pauthor, Pgenre, Prating) {
    let db = dbGetHandle()
    let rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO book_log (bookTitle, author, genre, rating) VALUES (?, ?, ?, ?)',
                      [PbookTitle, Pauthor, Pgenre, Prating])
        let result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function dbReadAll(listModel) {
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
            'SELECT rowid,bookTitle,author,genre,rating FROM book_log ORDER BY rowid DESC')
        for (let i = 0; i < results.rows.length; i++) {
            listModel.append({
                id: results.rows.item(i).rowid,
                checked: " ",
                bookTitle: results.rows.item(i).bookTitle,
                author: results.rows.item(i).author,
                genre: results.rows.item(i).genre,
                rating: results.rows.item(i).rating
            })
        }
    })
}

function dbUpdate(PbookTitle, Pauthor, Pgenre, Prating, Prowid) {
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql(
            'UPDATE book_log SET bookTitle=?, author=?, genre=?, rating=? WHERE rowid = ?', [PbookTitle, Pauthor, Pgenre, Prating, Prowid])
    })
}

function dbDeleteRow(Prowid) {
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('DELETE FROM book_log WHERE rowid = ?', [Prowid])
    })
}

// Add this function to your Database.js
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
            model.get(i).rating
        )
    }
}
