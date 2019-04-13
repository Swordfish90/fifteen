import QtQuick 2.2
import Felgo 3.0

import "utils.js" as Utils

EntityBase {
    id: tile
    entityType: "tile"

    property int tileIndex
    property int tileValue

    property int currentX: tileIndex % constants.gridSizeGame
    property int currentY: Math.floor(tileIndex / constants.gridSizeGame)

    property int goalX: tileValue % constants.gridSizeGame
    property int goalY: Math.floor(tileValue / constants.gridSizeGame)

    property color topColor: Utils.mixColors(constants.tileColor1, constants.tileColor2, goalX / constants.gridSizeGame)
    property color bottomColor: Utils.mixColors(constants.tileColor3, constants.tileColor4, goalX / constants.gridSizeGame)
    property color tileColor: Utils.mixColors(topColor, bottomColor, goalY)
    property color darkTileColor: Qt.darker(tileColor, 1.2)

    property real tileMargins: 2.5
    property int tileFontSize: width / 3

    width: constants.gridWidth / constants.gridSizeGame
    height: width

    x: width * currentX
    y: height * currentY

    Item {
        id: itemContainer
        anchors.fill: parent

        AppPaper {
            id: innerRect
            background.color: tileIndex === tileValue ? tileColor : darkTileColor
            background.border.color: darkTileColor
            background.border.width: 2
            anchors { fill: parent; margins: tileMargins }
            radius: constants.defaultRadius
        }

        Text {
            id: innerRectText
            anchors.centerIn: innerRect
            color: "#bbffffff"
            font.bold: true
            font.pixelSize: tileFontSize
            text: tileValue + 1
            z: 2
        }
    }

    Rectangle {
        id: highlightRectangle
        color: "#22ffffff"
        anchors { fill: parent; margins: tileMargins }
        radius: constants.defaultRadius
        visible: xAnim.running || yAnim.running
        z: 1
    }

    TileMotionBlur {
        anchors.fill: tile
        horizontalBlur: xAnim.running
        verticalBlur: yAnim.running
        source: itemContainer
    }

    Behavior on x {
        enabled: logic.state === logic.running
        NumberAnimation { id: xAnim; duration: constants.animationsDuration; }
    }

    Behavior on y {
        enabled: logic.state === logic.running
        NumberAnimation { id: yAnim; duration: constants.animationsDuration; }
    }
}
