import QtQuick
import QtQuick.LocalStorage
import "Database.js" as JS

ListModel {
    id: listModel
    Component.onCompleted: JS.dbReadAll()
}
