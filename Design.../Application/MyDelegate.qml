// MyDelegate.qml

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: delegate

    required property int index
    required property string bookTitle
    required property string author
    required property string genre
    required property string rating

    signal clicked()

    width: ListView.view.width
    implicitHeight: rBookTitle.implicitHeight * 1.5

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

        MouseArea {
            anchors.fill: parent
            onClicked: delegate.clicked()
        }

        RowLayout {
            anchors.fill: parent

            Label {
                id: rBookTitle
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.bookTitle
                font.pixelSize: 22
                color: "black"
            }

            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.author
                font.pixelSize: 22
                color: "black"
            }

            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.genre
                font.pixelSize: 22
                color: "black"
            }

            Label {
                Layout.preferredWidth: 42
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: delegate.rating
                font.pixelSize: 22
                color: "black"
            }
        }
    }
}
