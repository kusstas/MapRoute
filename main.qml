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

    AdvancedMap {
        id: map
        anchors.fill: parent
    }
}
