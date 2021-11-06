import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import Database 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Translator")

    id: main_window

    Database {
        id: database

        Component.onCompleted: {
            database.open();
            //database.initializeTable();
        }

        Component.onDestruction: {
            database.close();
        }

        onRuntimeError: {
            error_label.setError(error);
        }
    }

    ErrorLabel {
        id: error_label

        anchors.top: parent.top

        width: parent.width

        visible: false
    }

    property var direction: Database.RussianToEnglish

    SwipeView {
        anchors.fill: parent

        TranslatePage {
            database: database
        }

        Dictionary {
            database: database
        }
    }
}
