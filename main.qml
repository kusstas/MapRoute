import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("MapRoute")

    Material.theme: Material.Dark
    Material.accent: Material.Grey

    ColumnLayout {
        anchors.fill: parent
        spacing: 2

        AdvancedMap {
            id: map
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
