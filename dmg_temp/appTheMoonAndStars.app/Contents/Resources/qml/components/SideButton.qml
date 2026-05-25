import QtQuick
Rectangle {
    id: root
    property alias text: label.text
    property bool active: false
    signal clicked()
    width: 180; height: 42; radius: 2
    color: active ? "#12324d" : "transparent"
    border.color: active ? "#5ab4ff" : "#223040"
    border.width: 1
    Text { id: label; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 12; color: active ? "#8bd0ff" : "#d7e3ee"; font.pixelSize: 14; font.bold: true }
    MouseArea { anchors.fill: parent; onClicked: root.clicked() }
}
