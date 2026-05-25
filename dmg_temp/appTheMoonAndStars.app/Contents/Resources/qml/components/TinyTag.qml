import QtQuick
Rectangle { property string text: ""; width: 72; height: 18; radius: 9; color: "#102233"; border.color: "#274862"; Text { anchors.centerIn: parent; text: parent.text; color: "#b8d4ef"; font.pixelSize: 10; font.bold: true } }
