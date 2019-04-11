import QtQuick 2.2
import Felgo 3.0
import QtGraphicalEffects 1.0

import "utils.js" as Utils

EntityBase{
    id: tile
    entityType: "tile"

    property int tileIndex
    property int tileValue

    property int xIndex: (tileValue - 1) % constants.gridSizeGame
    property int yIndex: Math.floor((tileValue - 1) / constants.gridSizeGame)

    property color topColor: Utils.mixColors(constants.tileColor1, constants.tileColor2, xIndex / constants.gridSizeGame)
    property color bottomColor: Utils.mixColors(constants.tileColor3, constants.tileColor4, xIndex / constants.gridSizeGame)
    property color tileColor: Utils.mixColors(topColor, bottomColor, yIndex)

    property int tileFontSize: width / 3

    width: constants.gridWidth / constants.gridSizeGame
    height: width

    Item {
        id: itemContainer
        anchors.fill: parent

        AppPaper {
            id: innerRect
            background.color: tileColor
            background.border.color: Qt.darker(tileColor, 1.2)
            background.border.width: 2
            anchors.centerIn: parent
            width: parent.width - 5
            height: width
            radius: 5

            Text {
                id: innerRectText
                anchors.centerIn: parent
                color: "#bbffffff"
                font.bold: true
                font.pixelSize: tileFontSize
                text: tileValue
            }
        }
    }

    Rectangle {
        id: highlightRectangle

        color: "#22ffffff"
        anchors.centerIn: parent
        width: parent.width - 5
        height: width
        radius: 5
        visible: (xAnim.running || yAnim.running) ? true : false

        z: 1
    }

    // Let's add some motion blur when tiles are moving.
    DirectionalBlur {
        id: horizontalMotionBlur
        anchors.fill: tile
        source: itemContainer
        cached: true
        angle: 90
        length: 5
        samples: 3
        visible: xAnim.running
    }

    DirectionalBlur {
        id: verticalMotionBlur
        anchors.fill: tile
        source: itemContainer
        angle: 0
        cached: true
        length: 5
        samples: 3
        visible: yAnim.running
    }

    x: (width) * (tileIndex % constants.gridSizeGame)
    y: (height) * Math.floor(tileIndex / constants.gridSizeGame)

    Behavior on x {
        enabled: logic.state === logic.running
        NumberAnimation { id: xAnim; duration: constants.animationsDuration; }
    }

    Behavior on y {
        enabled: logic.state === logic.running
        NumberAnimation { id: yAnim; duration: constants.animationsDuration; }
    }
}
