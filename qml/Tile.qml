import QtQuick 2.2
import Felgo 3.0
import QtGraphicalEffects 1.0

import "utils.js" as Utils

EntityBase{

    id: tile
    entityType: "tile"

    property int tileIndex
    property int tileValue

    property int xIndex: (tileValue - 1) % gridSizeGame
    property int yIndex: Math.floor((tileValue - 1) / gridSizeGame)

    property color topColor: Utils.mixColors(constants.tileColor1, constants.tileColor2, xIndex / gridSizeGame)
    property color bottomColor: Utils.mixColors(constants.tileColor3, constants.tileColor4, xIndex / gridSizeGame)
    property color tileColor: Utils.mixColors(topColor, bottomColor, yIndex)

    property int tileFontSize: width / 3

    width: gridWidth / gridSizeGame
    height: width

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
            color: "white"
            font.pixelSize: tileFontSize
            text: tileValue
        }
    }

    x: (width) * (tileIndex % gridSizeGame)
    y: (height) * Math.floor(tileIndex / gridSizeGame)

    Behavior on x { NumberAnimation { duration: constants.animationsDuration } }
    Behavior on y { NumberAnimation { duration: constants.animationsDuration } }
}
