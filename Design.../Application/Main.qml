// Main.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage
import "Database.js" as JS

// Define the main window
Window {
    id: window

    // Define properties to manage the state of new entry creation and editing
    property bool creatingNewEntry: false
    property bool editingEntry: false

    // Set window properties
    visible: true
    width: Screen.width / 2
    height: Screen.height / 1.8
    color: "#161616"

    // Define the main layout
    Rectangle {
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            // Title label
            Label {
                Layout.alignment: Qt.AlignCenter
                text: qsTr("MyBookList")
                font.pointSize: 30
            }

            // Buttons row layout
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter

                // New button
                Button {
                    text: qsTr("New")
                    onClicked: {
                        input.initrec_new()
                        window.creatingNewEntry = true
                        listView.model.setProperty(listView.currentIndex, "id", 0)
                    }
                }

                // Save button
                Button {
                    id: saveButton
                    enabled: (window.creatingNewEntry || window.editingEntry) && listView.currentIndex !== -1
                    text: qsTr("Save")
                    onClicked: {
                        let insertedRow = false;
                        if (listView.model.get(listView.currentIndex).id < 1) {
                            // insert mode
                            if (input.insertrec()) {
                                // Successfully inserted a row.
                                input.setlistview()
                                insertedRow = true
                            } else {
                                // Failed to insert a row; display an error message.
                                statustext.displayWarning(qsTr("Failed to insert row"))
                            }
                        } else {
                            // edit mode
                            input.setlistview()
                            JS.dbUpdate(
                                listView.model.get(listView.currentIndex).bookTitle,
                                listView.model.get(listView.currentIndex).author,
                                listView.model.get(listView.currentIndex).genre,
                                listView.model.get(listView.currentIndex).rating,
                                listView.model.get(listView.currentIndex).comment, // Include comment
                                listView.model.get(listView.currentIndex).id
                            )
                        }

                        if (insertedRow) {
                            input.initrec()
                            window.creatingNewEntry = false
                            window.editingEntry = false
                            listView.forceLayout()

                            // Save the entire model to the database after the update
                            JS.dbSaveModel(listView.model)
                        }
                    }
                }

                // Edit button
                Button {
                    id: editButton
                    text: qsTr("Edit")
                    enabled: !window.creatingNewEntry && !window.editingEntry && listView.currentIndex !== -1
                    onClicked: {
                        input.editrec(
                            listView.model.get(listView.currentIndex).bookTitle,
                            listView.model.get(listView.currentIndex).author,
                            listView.model.get(listView.currentIndex).genre,
                            listView.model.get(listView.currentIndex).rating,
                            listView.model.get(listView.currentIndex).comment, // Include comment
                            listView.model.get(listView.currentIndex).id
                        )

                        window.editingEntry = true
                    }
                }

                // Delete button
                Button {
                    id: deleteButton
                    text: qsTr("Delete")
                    enabled: !window.creatingNewEntry && listView.currentIndex !== -1
                    onClicked: {
                        JS.dbDeleteRow(listView.model.get(listView.currentIndex).id)
                        listView.model.remove(listView.currentIndex, 1)
                        if (listView.count === 0) {
                            // ListView doesn't automatically set its currentIndex to -1
                            // when the count becomes 0.
                            listView.currentIndex = -1
                        }
                    }
                }

                // Cancel button
                Button {
                    id: cancelButton
                    text: qsTr("Cancel")
                    enabled: (window.creatingNewEntry || window.editingEntry) && listView.currentIndex !== -1
                    onClicked: {
                        if (listView.model.get(listView.currentIndex).id === 0) {
                            // This entry had an id of 0, which means it was being created and hadn't
                            // been saved to the database yet, so we can safely remove it from the model.
                            listView.model.remove(listView.currentIndex, 1)
                        }
                        listView.forceLayout()
                        window.creatingNewEntry = false
                        window.editingEntry = false
                        input.initrec()
                    }
                }

                // Exit button
                Button {
                    text: qsTr("Exit")
                    onClicked: Qt.quit()
                }
            }

            // Header component
            Header {
                id: input
                Layout.fillWidth: true
                listView: listView
                enabled: window.creatingNewEntry || window.editingEntry
            }

            // Spacing item
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 5
            }

            // Label for saved books
            Label {
                Layout.alignment: Qt.AlignCenter
                text: qsTr("Saved Books")
                font.pointSize: 15
            }

            // Highlight bar component
            Component {
                id: highlightBar
                Rectangle {
                    width: listView.currentItem?.width ?? implicitWidth
                    height: listView.currentItem?.height ?? implicitHeight
                    color: "#00ffa1"
                }
            }

            // ListView to display saved books
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: MyModel {}
                delegate: MyDelegate {
                    width: listView.width
                    onClicked: ()=> listView.currentIndex = index
                }
                // Don't allow changing the currentIndex while the user is creating/editing values.
                enabled: !window.creatingNewEntry && !window.editingEntry

                highlight: highlightBar
                highlightFollowsCurrentItem: true
                focus: true
                clip: true

                // Header for the ListView
                header: Component {
                    RowLayout {
                        width: ListView.view.width
                        Repeater {
                            model: [qsTr("Book Title"), qsTr("Author"), qsTr("Genre"), qsTr("Rating"), qsTr("Comment")] // Include comment header
                            delegate: Label {
                                id: headerTitleDelegate
                                required property string modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.preferredWidth: 1
                                text: modelData
                                font {
                                    pointSize: 15
                                    bold: true
                                    underline: true
                                }
                                padding: 12
                                horizontalAlignment: Label.AlignHCenter
                            }
                        }
                    }
                }
            }

            // Status text label
            Label {
                id: statustext
                color: "red"
                font.bold: true
                font.pointSize: 20
                opacity: 0.0
                visible: opacity > 0
                Layout.alignment: Layout.Center

                // Function to display a warning message
                function displayWarning(text) {
                    statustext.text = text
                    statusAnim.restart()
                }

                // Connections for status messages
                Connections {
                    target: input
                    function onStatusMessage(msg) { statustext.displayWarning(msg); }
                }

                // Animation for status message
                SequentialAnimation {
                    id: statusAnim
                    OpacityAnimator {
                        target: statustext
                        from: 0.0
                        to: 1.0
                        duration: 50
                    }
                    PauseAnimation {
                        duration: 2000
                    }
                    OpacityAnimator {
                        target: statustext
                        from: 1.0
                        to: 0.0
                        duration: 50
                    }
                }
            }
        }
    }

    // Initialize the database and read saved data on component completion
    Component.onCompleted: {
        JS.dbInit()
        JS.dbReadAll(listView.model)
    }
}
