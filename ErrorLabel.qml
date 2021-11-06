import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    function setError(error) {
        text.text = error;
        this.visible = true;
        timer.start();
    }

    z: 2

    Timer {
        id: timer

        interval: 10000

        onTriggered: {
            parent.visible = false;
        }
    }

    Label {
        id: text

        width: parent.width

        color: 'white'

        font.pointSize: 16

        background: Rectangle {
            color: 'red'
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
