// Header.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage
import "Database.js" as JS

// Define a custom item for the header
Item {
    id: root
    // Define a required property for the ListView
    required property ListView listView
    // Define a signal to emit status messages
    signal statusMessage(string msg)

    // Set the dimensions and initial state of the header
    width: Screen.width / 2
    height: Screen.height / 7
    enabled: false

    // Function to insert a new record into the database
    function insertrec() {
        // Insert the new record and update the ListView
        const rowid = parseInt(JS.dbInsert(bookTitleInput.text, authorInput.text, genreInput.text, ratingInput.text, commentInput.text), 10)
        if (rowid) {
            listView.model.setProperty(listView.currentIndex, "id", rowid)
            listView.forceLayout()
        }
        return rowid;
    }

    // Function to populate input fields for editing an existing record
    function editrec(PbookTitle, Pauthor, Pgenre, Prating, Pcomment, Prowid) {
        bookTitleInput.text = PbookTitle
        authorInput.text = Pauthor
        genreInput.text = Pgenre
        ratingInput.text = Prating
        commentInput.text = Pcomment
    }

    // Function to initialize input fields for a new record
    function initrec_new() {
        // Clear input fields and insert a new record into the ListView
        bookTitleInput.clear()
        authorInput.clear()
        genreInput.clear()
        ratingInput.clear()
        commentInput.clear()
        listView.model.insert(0, {
            bookTitle: "",
            author: "",
            genre: "",
            rating: "",
            comment: ""
        })
        listView.currentIndex = 0
        bookTitleInput.forceActiveFocus()
    }

    // Function to clear input fields
    function initrec() {
        bookTitleInput.clear()
        authorInput.clear()
        genreInput.clear()
        ratingInput.clear()
        commentInput.clear()
    }

    // Function to update the ListView with input field values
    function setlistview() {
        listView.model.setProperty(listView.currentIndex, "bookTitle", bookTitleInput.text)
        listView.model.setProperty(listView.currentIndex, "author", authorInput.text)
        listView.model.setProperty(listView.currentIndex, "genre", genreInput.text)
        listView.model.setProperty(listView.currentIndex, "rating", ratingInput.text)
        listView.model.setProperty(listView.currentIndex, "comment", commentInput.text)
    }

    // Define the visual layout of the header
    Rectangle {
        id: rootrect
        border.width: 10
        color: "#161616"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -225

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent

            Rectangle {
                id: gridBox

                GridLayout {
                    id: gridLayout
                    rows: 5
                    flow: GridLayout.TopToBottom
                    anchors.fill: parent

                    // Labels for input fields
                    Label {}
                    Label {}
                    Label {}
                    Label {}
                    Label {}

                    // Input fields for book details
                    RowLayout {
                        spacing: 10
                        Label {
                            text: qsTr("Book Title")
                            font.pixelSize: 22
                        }
                        TextField {
                            id: bookTitleInput
                            font.pixelSize: 22
                            activeFocusOnPress: true
                            activeFocusOnTab: true
                            Layout.preferredWidth: 227
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label {
                            text: qsTr("Author")
                            font.pixelSize: 22
                            rightPadding: 31
                        }
                        TextField {
                            id: authorInput
                            property string oldString
                            font.pixelSize: 22
                            activeFocusOnPress: true
                            activeFocusOnTab: true
                            Layout.preferredWidth: 227
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label {
                            text: qsTr("Genre")
                            font.pixelSize: 22
                            rightPadding: 38
                        }
                        TextField {
                            id: genreInput
                            property string oldString
                            font.pixelSize: 22
                            activeFocusOnPress: true
                            activeFocusOnTab: true
                            Layout.preferredWidth: 227
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label {
                            text: qsTr("Rating")
                            font.pixelSize: 22
                            rightPadding: 36
                        }
                        TextField {
                            id: ratingInput
                            property string oldString
                            font.pixelSize: 22
                            activeFocusOnPress: true
                            activeFocusOnTab: true
                            Layout.preferredWidth: 227
                        }
                    }
                    RowLayout {
                        spacing: 10
                        Label {
                            text: qsTr("Comment")
                            font.pixelSize: 22
                            rightPadding: 1
                        }
                        TextField {
                            id: commentInput
                            property string oldString
                            font.pixelSize: 22
                            activeFocusOnPress: true
                            activeFocusOnTab: true
                            Layout.preferredWidth: 227
                        }
                    }
                }
            }
        }
    }

    // Mouse area to handle focus
    MouseArea {
        anchors.fill: parent
        onClicked: bookTitleInput.forceActiveFocus()
    }
}
