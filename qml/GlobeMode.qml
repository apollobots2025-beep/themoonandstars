import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import "."
Item {
    id: root
    anchors.fill: parent
    signal enterTravelMode()
    signal selectObject(int index)

    Rectangle { anchors.fill: parent; color: "#000000" }

    Rectangle {
        x: 0; y: 0; width: 176; height: parent.height
        color: "#090d12"; border.color: "#1d2b3a"; border.width: 1
        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 10
            Text { text: "The Moon And Stars"; color: "#dce6ef"; font.pixelSize: 16 }
            Rectangle { width: parent.width; height: 1; color: "#223041" }
            SideButton { text: "GLOBE MODE"; active: true }
            SideButton { text: "TRAVEL MODE"; onClicked: root.enterTravelMode() }
            SideButton { text: "LOAD DATA"; onClicked: appModel.loadData() }
            SideButton { text: "SEARCH"; onClicked: searchField.forceActiveFocus() }
            SideButton { text: "TIMELINE"; onClicked: {} }
            SideButton { text: "SOURCE MAP"; onClicked: {} }
            SideButton { text: "ABOUT"; onClicked: {} }
            Item { height: 10; width: 1 }
            Rectangle { width: parent.width; height: 1; color: "#223041" }
            Text { text: "DATA STATUS"; color: "#d8e3ee"; font.pixelSize: 12; font.bold: true }
            Text { text: appModel.statusText; color: "#b8c4d0"; font.pixelSize: 12; wrapMode: Text.WordWrap }
            StatusPill { text: appModel.objectCount + " records" }
        }
    }

    Column {
        x: parent.width - 338; y: 38; width: 324; spacing: 12
        InfoPanel {
            width: 324; title: "SELECTED OBJECT"
            Column {
                spacing: 10
                Rectangle {
                    width: 296; height: 88; radius: 2; color: "#0d1218"; border.color: "#243244"
                    Column { anchors.centerIn: parent; spacing: 4; Text { text: appModel.selectedName; color: "#ffffff"; font.pixelSize: 18; font.bold: true; wrapMode: Text.WordWrap } Text { text: appModel.selectedType; color: "#bfc7d1"; font.pixelSize: 13 } }
                }
                LabelValue { labelText: "Source:"; valueText: appModel.selectedSource }
                LabelValue { labelText: "Distance:"; valueText: appModel.selectedDistance }
                LabelValue { labelText: "Diameter:"; valueText: appModel.selectedDiameter }
                LabelValue { labelText: "Magnitude:"; valueText: appModel.selectedMagnitude }
                LabelValue { labelText: "Right Ascension:"; valueText: appModel.selectedRA }
                LabelValue { labelText: "Declination:"; valueText: appModel.selectedDec }
                StyledButton { width: 296; text: "VIEW IN TRAVEL MODE"; onClicked: root.enterTravelMode() }
            }
        }
        InfoPanel {
            width: 324; title: "COSMOLOGY"
            Column {
                spacing: 10
                LabelValue { labelText: "Cosmic Time:"; valueText: appModel.cosmicTime.toFixed(3) + " Billion Years" }
                Slider { width: 296; from: 0; to: 13.787; value: appModel.cosmicTime; onMoved: appModel.cosmicTime = value }
                Row { spacing: 10; MetricChip { title: "Start"; value: "0" } MetricChip { title: "Now"; value: "13.787B" } }
                LabelValue { labelText: "Expansion:"; valueText: "ΛCDM scale factor" }
                LabelValue { labelText: "Measured:"; valueText: appModel.onlyMeasured ? "Yes" : "No" }
            }
        }
    }

    Text { x: 22; y: 18; text: "GLOBE MODE"; color: "#ffffff"; font.pixelSize: 28; font.bold: true; letterSpacing: 1.2 }
    Text { x: 22; y: 50; text: "Drag to rotate the observable universe"; color: "#d9e7f4"; font.pixelSize: 16 }

    Rectangle {
        x: 190; y: 76; width: 360; height: 36; radius: 3; color: "#0b1119cc"; border.color: "#26405c"
        TextField {
            id: searchField
            anchors.fill: parent
            anchors.margins: 4
            placeholderText: "Search by name, source, category..."
            color: "#ffffff"
            background: Rectangle { color: "transparent" }
            onTextChanged: appModel.searchText = text
        }
    }
    Rectangle {
        x: 190; y: 120; width: 360; height: 64; radius: 3; color: "#0b1119cc"; border.color: "#26405c"
        Row { anchors.fill: parent; anchors.margins: 8; spacing: 8; StyledButton { width: 108; text: "ALL"; selected: appModel.categoryFilter === "All"; onClicked: appModel.categoryFilter = "All" } StyledButton { width: 108; text: "STARS"; selected: appModel.categoryFilter === "Star"; onClicked: appModel.categoryFilter = "Star" } StyledButton { width: 108; text: "GALAXIES"; selected: appModel.categoryFilter === "Galaxy"; onClicked: appModel.categoryFilter = "Galaxy" } }
    }
    Rectangle {
        x: 190; y: 192; width: 360; height: 34; radius: 3; color: "#0b1119cc"; border.color: "#26405c"
        Row { anchors.fill: parent; anchors.margins: 8; spacing: 10; Text { text: "Measured sizes only"; color: "#cfe9ff"; anchors.verticalCenter: parent.verticalCenter } Switch { checked: appModel.onlyMeasured; onToggled: appModel.onlyMeasured = checked } }
    }
    Rectangle {
        x: 190; y: 236; width: 360; height: 680; radius: 4; color: "#081019cc"; border.color: "#26405c"
        ListView {
            anchors.fill: parent; anchors.margins: 10
            model: appModel.searchText.length > 0 ? appModel.searchResults : appModel.objects
            clip: true; spacing: 6
            delegate: Rectangle {
                required property var modelData; required property int index
                width: ListView.view.width - 20; height: 60; radius: 2; color: "#0e1520"; border.color: "#23344a"
                Row {
                    anchors.fill: parent; anchors.margins: 8; spacing: 10
                    Column { width: parent.width - 110; Text { text: modelData.name; color: "#ffffff"; font.pixelSize: 14; font.bold: true; elide: Text.ElideRight } Text { text: modelData.category + "  •  " + modelData.source; color: "#b8c4d0"; font.pixelSize: 11; elide: Text.ElideRight } }
                    Column { width: 90; Text { text: modelData.radiusText; color: "#9fd7ff"; font.pixelSize: 11; horizontalAlignment: Text.AlignRight; width: 90 } Text { text: modelData.distanceText; color: "#cfe9ff"; font.pixelSize: 11; horizontalAlignment: Text.AlignRight; width: 90 } }
                }
                MouseArea { anchors.fill: parent; onClicked: appModel.searchText.length > 0 ? appModel.focusOnSearchResult(index) : appModel.selectObject(index) }
            }
        }
    }

    View3D {
        x: 176; y: 0; width: parent.width - 176 - 338; height: parent.height
        environment: SceneEnvironment { backgroundMode: SceneEnvironment.Color; clearColor: "#000000"; antialiasingMode: SceneEnvironment.MSAA; antialiasingQuality: SceneEnvironment.High }
        Node {
            id: sceneRoot
            Node {
                id: orbitRoot
                eulerRotation.y: dragHandler.rotationY
                eulerRotation.x: dragHandler.rotationX
                PerspectiveCamera { id: orbitCamera; position: Qt.vector3d(0, 0, 260); clipNear: 0.1; clipFar: 100000 }
                DirectionalLight { eulerRotation.x: -25; eulerRotation.y: 35; brightness: 2.0 }
                Model { source: "#Sphere"; scale: Qt.vector3d(220, 220, 220); materials: PrincipledMaterial { baseColor: "#060a10"; roughness: 1.0 } }
                Repeater3D {
                    model: appModel.objects
                    delegate: Node {
                        required property var modelData; required property int index
                        position: Qt.vector3d(modelData.x * 4.5, modelData.y * 4.5, modelData.z * 4.5)
                        Model { source: "#Sphere"; scale: Qt.vector3d(modelData.sizeWorld, modelData.sizeWorld, modelData.sizeWorld); materials: PrincipledMaterial { baseColor: modelData.category.indexOf("Star") >= 0 ? "#dbe8ff" : (modelData.category.indexOf("Exoplanet") >= 0 ? "#f0d0b3" : "#f5d7a5"); emissiveFactor: Qt.vector3d(0.12, 0.12, 0.12); roughness: 0.4 } }
                        TapHandler { onTapped: appModel.selectObject(index) }
                    }
                }
                Node { visible: appModel.selectedName !== "No object selected"; position: Qt.vector3d(appModel.travelTarget.x * 4.5, appModel.travelTarget.y * 4.5, appModel.travelTarget.z * 4.5); Model { source: "#Sphere"; scale: Qt.vector3d(6, 6, 6); materials: PrincipledMaterial { baseColor: "#ffdd88"; emissiveFactor: Qt.vector3d(0.4, 0.3, 0.1) } } }
            }
            OrbitCameraController { camera: orbitCamera; origin: orbitRoot; xSpeed: 0.8; ySpeed: 0.8; mouseEnabled: true; panEnabled: true }
        }
        DragHandler { id: dragHandler; target: null; property real rotationX: -10; property real rotationY: 0; onTranslationChanged: { rotationY += translation.x * 0.25; rotationX = Math.max(-90, Math.min(90, rotationX + translation.y * 0.25)) } }
    }

    Rectangle { x: parent.width * 0.34; y: parent.height - 54; width: parent.width * 0.32; height: 30; radius: 2; color: "#0b0f15"; border.color: "#263247"; Text { anchors.centerIn: parent; text: "Observable Universe Sphere   |   real catalogs only   |   cosmology-aware scale"; color: "#e5edf6"; font.pixelSize: 13 } }
}
