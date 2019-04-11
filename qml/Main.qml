import Felgo 3.0
import QtQuick 2.0

import QtQuick.Layouts 1.11

GameWindow {
    id: gameWindow

    property var tiles: []

    activeScene: scene

    screenWidth: 640
    screenHeight: 960

    EntityManager {
        id: entityManager
        entityContainer: gameContent
    }

    Constants {
        id: constants
    }

    Logic {
        id: logic
        gridSizeGame: constants.gridSizeGame
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

            RowLayout {
                id: header
                anchors { margins: constants.defaultMargins; left: parent.left; right: parent.right }

                IconButton {
                    color: constants.foregroundColor
                    icon: IconType.clocko
                }

                AppText {
                    color: constants.foregroundColor
                    font.bold: true
                    text: logic.time.toFixed(1)
                }

                Item {
                    Layout.fillWidth: true
                }

                IconButton {
                    color: constants.foregroundColor
                    icon: IconType.undo
                    onClicked: logic.restart()
                }
            }

            Item {
                anchors {
                    top: header.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                Item {
                    id: gameContent

                    anchors.centerIn: parent

                    width: constants.gridWidth
                    height: width
                }

                MouseArea {
                    anchors.fill: gameContent
                    onClicked: {
                        var xValue = Math.floor(mouseX * constants.gridSizeGame / width)
                        var yValue = Math.floor(mouseY * constants.gridSizeGame / height)
                        logic.onCellClicked(xValue, yValue)
                    }
                }
            }
        }

        Connections {
            target: logic
            onModelUpdated: scene.updateTiles(model)
            onStateChanged: {
                if (logic.state === logic.ready) {
                    scene.initializeTiles(logic.model)
                } else if (logic.state === logic.uninitialized) {
                    scene.destroyTiles()
                } else if (logic.state === logic.finished) {
                    NativeDialog.confirm("Congratulations!", "You completed the puzzle in " + logic.time.toFixed(1) + " seconds." , undefined, false)
                }
            }
        }

        function destroyTiles() {
            entityManager.removeAllEntities()
            tiles = []
        }

        function initializeTiles(model) {
            for (var i = 0; i < model.length - 1; i++) {
                var tileId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("Tile.qml"), { tileIndex : i, tileValue: i })
                tiles.push(entityManager.getEntityById(tileId))
            }
            updateTiles(logic.model)
        }

        function updateTiles(model) {
            for (var i = 0; i < model.length; i++) {
                var tileIndex = model[i] - 1
                if (tileIndex >= 0)
                    tiles[tileIndex].tileIndex = i
            }
        }

        Component.onCompleted: {
            logic.restart()
        }
    }
}
