import Felgo 3.0
import QtQuick 2.0


GameWindow {
    id: gameWindow

    readonly property int empty: 0

    property int gridWidth: 300 // width and height of the game grid
    property int gridSizeGame: 4 // game grid size in tiles
    property int gridSizeGameSquared: gridSizeGame * gridSizeGame

    property var tiles: new Array()

    activeScene: scene

    screenWidth: 640
    screenHeight: 960

    EntityManager {
        id: entityManager
        entityContainer: gameBackground
    }

    QtObject {
        id: constants
        property color backgroundColor: "#3c4564"
        property color backgroundColorTop: backgroundColor
        property color backgroundColorBottom: Qt.darker(backgroundColorTop, 1.5)

        property real value: 0.9
        property real saturation: 0.5

        // Tile colors are interpolated using these 4 bases.
        property color tileColor1: Qt.hsva(0.65, saturation, value, 1.0)
        property color tileColor2: Qt.hsva(0.72, saturation, value, 1.0)
        property color tileColor3: Qt.hsva(0.79, saturation, value, 1.0)
        property color tileColor4: Qt.hsva(0.85, saturation, value, 1.0)
    }

    Logic {
        id: logic
    }

    Scene {
        id: scene

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 320
        height: 480

        Rectangle {
            id: background
            anchors.fill: scene.gameWindowAnchorItem
            gradient: Gradient {
                GradientStop { position: 0.0; color: constants.backgroundColorTop }
                GradientStop { position: 1.0; color: constants.backgroundColorBottom }
            }
        }

        GameBackground {
            id: gameBackground
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: gameBackground
            onClicked: {
                var xValue = Math.floor(mouseX * gridSizeGame / width)
                var yValue = Math.floor(mouseY * gridSizeGame / height)
                logic.onCellClicked(xValue, yValue)
            }
        }

        Connections {
            target: logic
            onModelUpdated: scene.updateTiles(model)
        }

        function initializeTiles(model) {
            for (var i = 0; i < model.length; i++) {
                if (model[i] !== empty) {
                    var tileId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("Tile.qml"), { tileIndex : i, tileValue: model[i] })
                    tiles.push(entityManager.getEntityById(tileId))
                }
            }
        }

        function updateTiles(model) {
            for (var i = 0; i < model.length; i++) {
                for (var j = 0; j < tiles.length; j++) {
                    if (model[i] === tiles[j].tileValue) {
                        tiles[j].tileIndex = i
                    }
                }
            }
        }

        Component.onCompleted: {
            logic.initializeModel()
            initializeTiles(logic.model)
        }
    }
}
