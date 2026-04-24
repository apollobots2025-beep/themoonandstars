import QtQuick
Rectangle { property string text: ""; width: 90; height: 22; radius: 11; color: "#0e1621"; border.color: "#35506d"; Text { anchors.centerIn: parent; text: parent.text; color: "#d4e9ff"; font.pixelSize: 11; font.bold: true } }
