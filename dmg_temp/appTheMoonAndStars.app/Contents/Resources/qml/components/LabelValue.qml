import QtQuick
Row { property string labelText: ""; property string valueText: ""; spacing: 8; Text { text: labelText; color: "#c6d0db"; font.pixelSize: 14 } Text { text: valueText; color: "#ffffff"; font.pixelSize: 14; font.family: "Consolas" } }
