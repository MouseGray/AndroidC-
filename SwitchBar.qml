import QtQuick 2.0

Row {
    property alias leftPart: left
    property alias rightPart: right
    property alias button: btn

    signal switched()

    Text {
        id: left

        width: (parent.width - parent.height) / 2
        height: parent.height

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pointSize: 18
    }

    Image {
        id: btn

        width: parent.height
        height: parent.height

        MouseArea {
            anchors.fill: parent

            onClicked: {
                let tmp = left.text;
                left.text = right.text;
                right.text = tmp;
                switched();
            }
        }
    }

    Text {
        id: right

        width: (main_window.width - parent.height) / 2
        height: parent.height

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pointSize: 18
    }
}
