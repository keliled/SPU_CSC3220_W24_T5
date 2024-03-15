// ListModel.qml

// Import necessary modules
import QtQuick
import QtQuick.LocalStorage
import "Database.js" as JS

// Define ListModel
ListModel {
    // Set id for referencing
    id: listModel
    
    // Call dbReadAll function from Database.js when Component is completed
    Component.onCompleted: JS.dbReadAll(listModel)
}
