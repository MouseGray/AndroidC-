import QtQuick 2.0
import QtQuick.Controls 2.12

Dialog {
    property alias text: text.text

    anchors.centerIn: parent

    height: 130
    width: 250

    standardButtons: Dialog.Ok | Dialog.Cancel

    Text {
        id: text

        anchors.fill: parent

        font.pointSize: 20

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
