import QtQuick 2.0

Text {
    property bool state: true
    property string firstText
    property string secondText

    signal changed(bool state)

    text: firstText

    MouseArea {
        anchors.fill: parent

        onClicked: {
            let state = parent.state;
            parent.state = !state;

            changed(state);

            parent.text = state ? secondText : firstText;
        }
    }
}
