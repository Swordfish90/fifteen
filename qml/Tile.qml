import QtQuick 2.2
import Felgo 3.0

EntityBase{

    id: tile
    entityType: "tile"

    property int tileIndex
    property int tileValue

    width: gridWidth / gridSizeGame
    height: width // square so height=width

    // tileFontSize is deduced from the tile width, so it fits into any grid size
    property int tileFontSize: width / 3

    // tile rectangle
    Rectangle {
        id: innerRect
        anchors.centerIn: parent // center this object in the invisible "EntityBase"
        width: parent.width - 2 // -2 is the width offset, set it to 0 if no offset is needed
        height: width // square so height=width
        radius: 4 // radius of tile corners
        color: "#88B605"

        // tile text
        Text {
            id: innerRectText
            anchors.centerIn: parent // center this object in the "innerRect"
            color: "white"
            font.pixelSize: tileFontSize
            text: tileValue
        }
    }

    x: (width) * (tileIndex % gridSizeGame) // we get the current row and multiply with the width to get the current position
    y: (height) * Math.floor(tileIndex / gridSizeGame)

    Behavior on x { NumberAnimation { duration: 200 } }
    Behavior on y { NumberAnimation { duration: 200 } }

    // destroy function
    function destroyTile() {
        removeEntity()
    }
}
