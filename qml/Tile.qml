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
    property alias tileColor: innerRect.color

    property color topColor: Utils.mixColors(constants.tileColor1, constants.tileColor2, xIndex / gridSizeGame)
    property color bottomColor: Utils.mixColors(constants.tileColor3, constants.tileColor4, xIndex / gridSizeGame)

    tileColor: Utils.mixColors(topColor, bottomColor, yIndex)

    width: gridWidth / gridSizeGame
    height: width // square so height=width

    // tileFontSize is deduced from the tile width, so it fits into any grid size
    property int tileFontSize: width / 3

    // tile rectangle
    Rectangle {
        id: innerRect
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

        RectangularGlow {
            id: effect
            anchors.fill: innerRect
            glowRadius: 5
            cached: true
            spread: 0.2
            color: "#77000000"
            z: -1
            cornerRadius: innerRect.radius + glowRadius
        }
    }

    x: (width) * (tileIndex % gridSizeGame)
    y: (height) * Math.floor(tileIndex / gridSizeGame)

    Behavior on x { NumberAnimation { duration: 200 } }
    Behavior on y { NumberAnimation { duration: 200 } }

    // destroy function
    function destroyTile() {
        removeEntity()
    }
}
