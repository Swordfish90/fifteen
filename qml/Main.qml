import Felgo 3.0
import QtQuick 2.0

import "utils.js" as Utils

GameWindow {
    id: gameWindow

    readonly property int empty: 0

    property int gridWidth: 300 // width and height of the game grid
    property int gridSizeGame: 4 // game grid size in tiles
    property int gridSizeGameSquared: gridSizeGame * gridSizeGame

    property var model: new Array(gridSizeGameSquared)
    property var tiles: new Array()

    activeScene: scene

    screenWidth: 640
    screenHeight: 960

    EntityManager {
        id: entityManager
        entityContainer: gameBackground
    }

    Scene {
        id: scene

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 320
        height: 480

        Rectangle {
            id: background
            anchors.fill: scene.gameWindowAnchorItem
            color: "#B6581A"
            border.width: 5
            border.color: "#4A230B"
            radius: 10 // radius of the corners
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
                scene.onCellClicked(xValue, yValue)
            }
        }

        function initializeModel() {
            model = []

            model.push(empty)
            for (var i = 1; i < gridSizeGameSquared; i++) {
                model.push(i)
            }

            Utils.shuffle(model)
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

        function onCellClicked(x, y) {
            if (isEmpty(x + 1, y)) {
                move(x, y, x + 1, y)
            } else if (isEmpty(x - 1, y)) {
                move(x, y, x - 1, y)
            } else if (isEmpty(x, y + 1)) {
                move(x, y, x, y + 1)
            } else if (isEmpty(x, y - 1)) {
                move(x, y, x, y - 1)
            }
        }

        function isEmpty(x, y) {
            return model[coordsToIndex(x, y)] === empty;
        }

        function move(x1, y1, x2, y2) {
            if (isInGame(x2, y2)) {
                var fromIndex = coordsToIndex(x1, y1)
                var toIndex = coordsToIndex(x2, y2)
                Utils.swap(model, fromIndex, toIndex)
                updateTiles(model)
            }
        }

        function isInGame(x, y) {
            return x >= 0 && x < gridSizeGame && y >= 0 && y < gridSizeGame
        }

        function coordsToIndex(x, y) {
            return x + y * gridSizeGame
        }

        Component.onCompleted: {
            initializeModel()
            initializeTiles(model)
        }
    }
}
