// MyDelegate.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// Define the delegate item
Item {
    id: delegate

    // Define required properties
    required property int index
    required property string bookTitle
    required property string author
    required property string genre
    required property string rating
    required property string comment

    // Define signal for click event
    signal clicked()

    // Set width to match the ListView's width and implicit height based on the height of the book title label
    width: ListView.view.width
    implicitHeight: rBookTitle.implicitHeight * 1.5

    // Define the background rectangle
    Rectangle {
        id: baseRec
        anchors.fill: parent
        opacity: 0.8
        color: delegate.index % 2 ? "lightgrey" : "grey"
        border {
            width: 2
            color: Qt.lighter(color)
        }
        radius: 5

        // Define mouse area for click detection
        MouseArea {
            anchors.fill: parent
            onClicked: delegate.clicked()
        }

        // Row layout for displaying book details
        RowLayout {
            anchors.fill: parent

            // Label for book title
            Label {
                id: rBookTitle
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.bookTitle
                font.pixelSize: 22
                color: "black"
            }

            // Label for author
            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.author
                font.pixelSize: 22
                color: "black"
            }

            // Label for genre
            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.genre
                font.pixelSize: 22
                color: "black"
            }

            // Label for rating
            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.rating
                font.pixelSize: 22
                color: "black"
            }

            // Label for comment
            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.comment
                font.pixelSize: 22
                color: "black"
            }
        }
    }
}
