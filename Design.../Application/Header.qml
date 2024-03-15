// Header.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage
import "Database.js" as JS

Item {
    id: root
    required property ListView listView
    signal statusMessage(string msg)

    width: Screen.width / 2
    height: Screen.height / 7
    enabled: false

    function insertrec() {
        const rowid = parseInt(JS.dbInsert(bookTitleInput.text, authorInput.text, genreInput.text, ratingInput.text, commentInput.text), 10)
        if (rowid) {
            listView.model.setProperty(listView.currentIndex, "id", rowid)
            listView.forceLayout()
        }
        return rowid;
    }

    function editrec(PbookTitle, Pauthor, Pgenre, Prating, Pcomment, Prowid) {
        bookTitleInput.text = PbookTitle
        authorInput.text = Pauthor
        genreInput.text = Pgenre
        ratingInput.text = Prating
        commentInput.text = Pcomment
    }

    function initrec_new() {
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

    function initrec() {
        bookTitleInput.clear()
        authorInput.clear()
        genreInput.clear()
        ratingInput.clear()
        commentInput.clear()
    }

    function setlistview() {
        listView.model.setProperty(listView.currentIndex, "bookTitle", bookTitleInput.text)
        listView.model.setProperty(listView.currentIndex, "author", authorInput.text)
        listView.model.setProperty(listView.currentIndex, "genre", genreInput.text)
        listView.model.setProperty(listView.currentIndex, "rating", ratingInput.text)
        listView.model.setProperty(listView.currentIndex, "comment", commentInput.text)
    }

    Rectangle {
            id: rootrect
            border.width: 10
            color: "#161616"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -225

            ColumnLayout {
                id: mainLayout
                anchors.fill: parent
                //anchors.topMargin:


                Rectangle {
                    id: gridBox


                    //anchors.horizontalCenterOffset: +500 // Adjust the horizontal offset to move it to the left
                    // Center horizontally


                    GridLayout {
                        id: gridLayout
                        rows: 5
                        flow: GridLayout.TopToBottom
                        anchors.fill: parent

                        Label {

                        }

                        Label {
                        }

                        Label {
                        }

                        Label {
                        }

                        Label {
                        }


                        RowLayout {

                            spacing: 10 // Adjust spacing between label and input box

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
                            spacing: 10 // Adjust spacing between label and input box

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
                            spacing: 10 // Adjust spacing between label and input box

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
                            spacing: 10 // Adjust spacing between label and input box

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
                            spacing: 10 // Adjust spacing between label and input box

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
    MouseArea {
        anchors.fill: parent
        onClicked: bookTitleInput.forceActiveFocus()
    }
}
