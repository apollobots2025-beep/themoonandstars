import QtQuick
import QtQuick.Controls
import QtQuick3D
import "."
Item {
    id: root
    anchors.fill: parent
    signal exitTravelMode()

    Rectangle { anchors.fill: parent; color: "#000000" }
    Text { x: 28; y: 18; text: "TRAVEL MODE"; color: "#ffffff"; font.pixelSize: 28; font.bold: true; letterSpacing: 1.2 }
    Text { x: 28; y: 58; text: "Hold WASD to accelerate\nMouse drag to look around"; color: "#d9e7f4"; font.pixelSize: 16; lineHeight: 1.25 }

    View3D {
        anchors.fill: parent
        environment: SceneEnvironment { backgroundMode: SceneEnvironment.Color; clearColor: "#000000"; antialiasingMode: SceneEnvironment.MSAA; antialiasingQuality: SceneEnvironment.High }
        Node {
            PerspectiveCamera { id: travelCamera; position: travelController.position; eulerRotation.y: travelController.yaw; eulerRotation.x: travelController.pitch; clipNear: 0.1; clipFar: 100000 }
            DirectionalLight { eulerRotation.x: -20; eulerRotation.y: 20; brightness: 2.0 }
            Repeater3D {
                model: appModel.objects
                delegate: Node {
                    required property var modelData; required property int index
                    position: Qt.vector3d((index % 18 - 9) * 120, ((Math.floor(index / 18) % 10) - 5) * 90, -200 - (index * 60))
                    Model { source: "#Sphere"; scale: Qt.vector3d(modelData.sizeWorld, modelData.sizeWorld, modelData.sizeWorld); materials: PrincipledMaterial { baseColor: modelData.category.indexOf("Star") >= 0 ? "#cfe6ff" : (modelData.category.indexOf("Exoplanet") >= 0 ? "#f0d0b3" : "#d9b18d"); emissiveFactor: Qt.vector3d(0.12, 0.12, 0.12) } }
                }
            }
            Model { source: "#Sphere"; scale: Qt.vector3d(1800,1800,1800); materials: PrincipledMaterial { baseColor: "#000000"; roughness: 1.0 } }
        }
    }

    Rectangle { x: parent.width * 0.35; y: parent.height - 110; width: parent.width * 0.30; height: 100; radius: 8; color: "#04101caa"; border.color: "#23405c"; Text { anchors.centerIn: parent; text: "SPEED: " + travelController.speed.toFixed(1) + " units/s\nPOSITION: " + Math.round(travelController.position.x) + ", " + Math.round(travelController.position.y) + ", " + Math.round(travelController.position.z); color: "#9fd7ff"; font.pixelSize: 14; horizontalAlignment: Text.AlignHCenter } }
    Rectangle { x: parent.width - 325; y: 44; width: 300; height: 68; radius: 4; color: "#0b1119cc"; border.color: "#2a4a67"; Column { anchors.centerIn: parent; spacing: 2; Text { text: "Cosmic Time"; color: "#9ed7ff"; font.pixelSize: 14 } Text { text: appModel.cosmicTime.toFixed(3) + " Billion Years"; color: "#e8f4ff"; font.pixelSize: 18 } } }
    Rectangle { x: 22; y: parent.height - 220; width: 180; height: 185; radius: 4; color: "#0b1119cc"; border.color: "#26405c"; Column { anchors.fill: parent; anchors.margins: 10; spacing: 4; Text { text: "W"; color: "#ffffff"; font.pixelSize: 18; font.bold: true } Text { text: "Move Forward"; color: "#cfe9ff"; font.pixelSize: 12 } Text { text: "S"; color: "#ffffff"; font.pixelSize: 18; font.bold: true } Text { text: "Move Backward"; color: "#cfe9ff"; font.pixelSize: 12 } Text { text: "A"; color: "#ffffff"; font.pixelSize: 18; font.bold: true } Text { text: "Move Left"; color: "#cfe9ff"; font.pixelSize: 12 } Text { text: "D"; color: "#ffffff"; font.pixelSize: 18; font.bold: true } Text { text: "Move Right"; color: "#cfe9ff"; font.pixelSize: 12 } Text { text: "Shift / Space = vertical"; color: "#cfe9ff"; font.pixelSize: 12 } Text { text: "Hold keys to accelerate"; color: "#cfe9ff"; font.pixelSize: 12 } } }
    Rectangle { x: parent.width - 300; y: parent.height - 270; width: 280; height: 240; radius: 4; color: "#0b1119cc"; border.color: "#26405c"; Column { anchors.fill: parent; anchors.margins: 12; spacing: 8; Text { text: "CURRENT TARGET"; color: "#7fc8ff"; font.pixelSize: 14 } Text { text: appModel.selectedName; color: "#ffffff"; font.pixelSize: 18; wrapMode: Text.WordWrap } Text { text: "Type: " + appModel.selectedType + "\nDistance: " + appModel.selectedDistance + "\nDiameter: " + appModel.selectedDiameter + "\nMagnitude: " + appModel.selectedMagnitude + "\nSource: " + appModel.selectedSource; color: "#cfe9ff"; font.pixelSize: 12; wrapMode: Text.WordWrap } StyledButton { width: 256; text: "EXIT TRAVEL MODE"; onClicked: appModel.exitTravelMode() } } }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        property real lastX: 0
        property real lastY: 0
        acceptedButtons: Qt.LeftButton
        onPressed: { lastX = mouseX; lastY = mouseY; travelController.active = true }
        onPositionChanged: {
            if (!pressed) return
            travelController.setMouseLookDelta(mouseX - lastX, mouseY - lastY)
            lastX = mouseX
            lastY = mouseY
        }
        onReleased: travelController.active = true
    }
}
