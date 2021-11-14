import QtQuick 2.0
import QtQuick.Controls 2.12

import Database 1.0

import 'utils.js' as Utils

Item {
    property Database database

    id: page

    TextField {
        id: search_text_area

        anchors.top: page.top
        anchors.left: page.left
        anchors.right: page.right

        placeholderText: 'Слово'

        height: 50

        font.pointSize: 22

        background: Rectangle {
            anchors.fill: parent
        }

        validator: RegExpValidator {
            regExp: /[a-zA-Z]*|[а-яА-ЯёЁ]*/
        }

        onTextChanged: {
            let result;

            let word = text.toLowerCase();

            if (word.length === 0) {
                empty_label.text = 'Введите слово для поиска'

                empty_label.visible = true;
                empty_label.height = 25;

                result_model.clear();

                return;
            }

            console.log(word);
            if (Utils.is_english_letter(word[0])) {
                langs.leftColumn.text = 'Английский';
                langs.rightColumn.text = 'Русский';
                result = database.fetchWordPairs(word, Database.EnglishToRussian);
            }
            else {
                langs.leftColumn.text = 'Русский';
                langs.rightColumn.text = 'Английский';
                result = database.fetchWordPairs(word, Database.RussianToEnglish);
            }

            console.log(result);
            if (result.length === 0) {
                empty_label.visible = true;
                empty_label.height = 25;

                empty_label.text = 'Ничего не найдено'

                result_model.clear();
            }
            else {
                empty_label.visible = false;
                empty_label.height = 0;

                result_model.clear();

                for(let res of result) {
                    let parts = res.split(' ');
                    result_model.append({ first: parts[0], second: parts[1] });
                }
            }
        }
    }

    BicolumnText {
        id: langs

        anchors.top: search_text_area.bottom
        anchors.left: page.left
        anchors.right: page.right

        height: 25

        leftColumn.text: 'Русский'
        leftColumn.horizontalAlignment: Text.AlignHCenter

        rightColumn.text: 'Английский'
        rightColumn.horizontalAlignment: Text.AlignHCenter
    }

    Label {
        id: empty_label

        anchors.top: langs.bottom
        anchors.left: page.left
        anchors.right: page.right

        topPadding: 10

        text: 'Введите слово для поиска'

        font.pointSize: 14

        color: 'gray'

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    ListModel {
        id: result_model
    }

    ListView {
        id: result_view

        anchors.top: empty_label.bottom
        anchors.bottom: page.bottom
        anchors.left: page.left
        anchors.right: page.right

        model: result_model

        delegate: BicolumnText {

            width: result_view.width
            height: 25

            leftColumn.text: first
            leftColumn.anchors.leftMargin: 10

            rightColumn.text: second
            rightColumn.anchors.leftMargin: 10
        }
    }
}
