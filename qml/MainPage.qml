import Felgo 3.0
import QtQuick 2.0

Page {
    id: mainPage

    rightBarItem: NavigationBarRow {
        IconButtonBarItem {
            icon: IconType.undo
            onClicked: logic.restart()
        }

        IconButtonBarItem {
            icon: IconType.star
            onClicked: socialView.pushLeaderboardPage(constants.leaderboardBaseName + logic.gridSizeGame, undefined, navigationStack)
        }
    }

    leftBarItem: IconButtonBarItem {
        icon: IconType.navicon
        onClicked: appDrawer.open()
    }

    AppDrawer {
        id: appDrawer

        z: 2

        Rectangle {
            anchors.fill: parent
            color: constants.backgroundColor
        }

        AppListView {
            id: listView
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            delegate: SimpleRow {
                onSelected: {
                    logic.restartWithSize(listView.model[index].gameSize)
                    appDrawer.close()
                }
            }
            model: [
                { text: "3 x 3", gameSize: 3 },
                { text: "4 x 4", gameSize: 4 },
                { text: "5 x 5", gameSize: 5 }
            ]
        }
    }

    ListModel {
        id: listModel
    }

    Connections {
        target: logic
        onModelUpdated: mainPage.updateListModel()
        onStateChanged: {
            if (logic.state === logic.ready) {
                mainPage.initializeListModel()
                colorManager.updateColors()
            } else if (logic.state === logic.uninitialized) {
                listModel.clear()
            }
        }
    }

    Item {
        id: mainContainer
        anchors.centerIn: parent
        width: cellSize * logic.gridSizeGame
        height: cellSize * logic.gridSizeGame

        property real hCellSize: (parent.width - 2 * constants.defaultMargins) / logic.gridSizeGame
        property real vCellSize: (parent.height - 2 * constants.defaultMargins) / logic.gridSizeGame

        property int cellSize: Math.min(hCellSize, vCellSize, constants.cellMaxSize)

        Repeater {
            id: repeater
            model: listModel
            anchors.centerIn: parent
            delegate: Tile {
                width: mainContainer.cellSize
                height: width
                tileIndex: position
                tileValue: value

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var xPosition = position % logic.gridSizeGame
                        var yPosition = Math.floor(position / logic.gridSizeGame)
                        logic.onCellClicked(xPosition, yPosition)
                    }
                }
            }
        }
    }

    function initializeListModel() {
        console.log("Initializing new model")
        listModel.clear()
        for (var i = 0; i < logic.model.length - 1; i++) {
            listModel.append({ position: i, value: i })
        }
        updateListModel()
    }

    function updateListModel() {
        for (var i = 0; i < logic.model.length; i++) {
            var tilePosition = logic.model[i] - 1
            if (tilePosition >= 0) {
                listModel.setProperty(tilePosition, "position", i)
            }
        }
    }
}
