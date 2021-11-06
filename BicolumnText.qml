import QtQuick 2.0

Item {
    property alias leftColumn: left
    property alias rightColumn: right

    Text {
        id: left

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.horizontalCenter
        }

        font.pointSize: 20

        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: center_border

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.horizontalCenter
        }

        width: 1

        z: 1

        color: 'black'
    }

    Text {
        id: right

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.horizontalCenter
            right: parent.right
        }

        font.pointSize: 20

        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: bottom_border

        anchors {
            top: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 1

        z: 1

        color: 'black'
    }
}
