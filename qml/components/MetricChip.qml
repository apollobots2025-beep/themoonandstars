import QtQuick
Rectangle { property string title: ""; property string value: ""; width: 180; height: 40; radius: 4; color: "#0b1119"; border.color: "#26405c"; Text { anchors.centerIn: parent; text: title + ": " + value; color: "#cfe9ff"; font.pixelSize: 13 } }
