import QtQuick
import QtQuick.Controls
import MoonStars 1.0

ApplicationWindow {
    visible: true
    width: 1536
    height: 1024
    title: "The Moon And Stars"
    color: "#000000"
    focus: true

    GlobeMode {
        anchors.fill: parent
        visible: appModel.globeMode
        onEnterTravelMode: {
            appModel.enterTravelMode()
            travelController.active = true
            travelController.reset(Qt.vector3d(0,0,80))
        }
        onSelectObject: (index) => appModel.selectObject(index)
    }

    TravelMode {
        anchors.fill: parent
        visible: !appModel.globeMode
        onExitTravelMode: {
            appModel.exitTravelMode()
            travelController.active = false
        }
    }

    Keys.onPressed: (event) => {
        if (!appModel.globeMode) {
            if (event.key === Qt.Key_W) appModel.forwardHeld = true
            if (event.key === Qt.Key_S) appModel.backHeld = true
            if (event.key === Qt.Key_A) appModel.leftHeld = true
            if (event.key === Qt.Key_D) appModel.rightHeld = true
            if (event.key === Qt.Key_Space) appModel.upHeld = true
            if (event.key === Qt.Key_Shift) appModel.downHeld = true
        }
    }

    Keys.onReleased: (event) => {
        if (!appModel.globeMode) {
            if (event.key === Qt.Key_W) appModel.forwardHeld = false
            if (event.key === Qt.Key_S) appModel.backHeld = false
            if (event.key === Qt.Key_A) appModel.leftHeld = false
            if (event.key === Qt.Key_D) appModel.rightHeld = false
            if (event.key === Qt.Key_Space) appModel.upHeld = false
            if (event.key === Qt.Key_Shift) appModel.downHeld = false
        }
    }

    Component.onCompleted: appModel.loadData()
}
