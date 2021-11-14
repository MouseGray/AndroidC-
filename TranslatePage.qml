import QtQuick 2.12
import QtQuick.Controls 2.12

import Database 1.0
import TextProcessor 1.0

import 'utils.js' as Utils

Item {
    property var database;

    id: page

    TextProcessor {
        id: proc
    }

    Column {
        TextArea {
            id: text_area_from

            width: page.width
            height: (page.height - 40) / 2

            font.pointSize: 22
            placeholderText: 'Введите текст'

            onTextChanged: page.update()
        }

        SwitchBar {
            id: switch_bar

            width: page.width
            height: 40

            leftPart.text: 'Русский'
            rightPart.text: 'Английский'

            button.source: 'android/Arrow.svg'

            onSwitched: {
                direction = database.invertDirection(direction);
                page.update();
            }
        }

        TextArea {
            id: text_area_to

            width: page.width
            height: (page.height - 40) / 2

            readOnly: true
            font.pointSize: 22
            placeholderText: 'Перевод'

            Text {
                id: add_btn

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10

                topPadding: 5

                height: 25

                text: 'Добавить перевод'

                font.pointSize: 14

                visible: false

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        dialog.open();
                    }
                }
            }
        }
    }

    Item {
        id: synonyms

        anchors.bottom: page.bottom

        width: page.width
        height: 25
        z: 1

        StateButton {
            id: synonyms_btn

            anchors {
                right: parent.right
                top: parent.top
                rightMargin: 10
                topMargin: 5
            }

            firstText: 'Показать синонимы'
            secondText: 'Скрыть синонимы'

            font.pointSize: 14

            visible: false

            onChanged: {
                text_area_from.readOnly = state;
                synonyms_animation.to = state ? page.height - 15 : 25;
                synonyms_animation.start();
            }
        }

        Rectangle {
            id: synonyms_list

            anchors.bottom: parent.bottom

            width: synonyms.width
            height: synonyms.height - 25

            ListView {

                anchors.fill: parent

                model: ListModel {
                    id: synonyms_model
                }

                delegate: Text {
                    leftPadding: 10
                    rightPadding: 10

                    width: synonyms_list.width - 20
                    height: 30

                    text: word

                    font.pointSize: 20

                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            confirm_dialog.synonym = word;
                            confirm_dialog.open();
                        }
                    }
                }
            }
        }
    }

    PropertyAnimation {
        id: synonyms_animation
        target: synonyms
        property: "height"
        duration: 200
    }

    Dialog {
        id: dialog

        title: "Добавить перевод"

        anchors.centerIn: parent

        height: 170
        width: 325

        standardButtons: Dialog.Ok | Dialog.Cancel

        TextField {
            id: text_field

            anchors.fill: parent

            font.pointSize: 20

            validator: RegExpValidator {
                regExp: direction === Database.EnglishToRussian ? /[а-яА-ЯёЁ]*/ : /[a-zA-Z]*/
            }

            background: Rectangle {
                anchors.fill: parent

                border.width: 1
            }
        }

        onAccepted: {
            database.clearBestTranslation(text_area_from.text.toLowerCase(), direction);
            database.addTranslation(text_area_from.text.toLowerCase(), text_field.text.toLowerCase(), direction);

            page.update();
        }
    }

    ConfirmDialog {
        id: confirm_dialog

        property string synonym

        text: "Лучший перевод?"

        onAccepted: {
            database.clearBestTranslation(text_area_from.text.toLowerCase(), direction);
            database.setBestTranslation(text_area_from.text.toLowerCase(), synonym.toLowerCase(), direction);

            page.update();
        }
    }

    function update() {
        synonyms_model.clear();

        let result = proc.translate(database, text_area_from.text, direction);

        if (result.length === 0) {
            text_area_to.text = '';
        }
        else {
            text_area_to.text = result[0];
            for(let res of result) {
                synonyms_model.append({ word: res });
            }
        }

        add_btn.visible = Utils.is_one_word(text_area_from.text);

        synonyms_btn.visible = (result.length > 1);
    }
}
