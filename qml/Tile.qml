import QtQuick 2.2
import Felgo 3.0

import "utils.js" as Utils

Item {
    id: tile

    property int tileIndex
    property int tileValue

    property int gridSizeGame: logic.gridSizeGame

    property int currentX: tileIndex % gridSizeGame
    property int currentY: Math.floor(tileIndex / gridSizeGame)

    property int goalX: tileValue % gridSizeGame
    property int goalY: Math.floor(tileValue / gridSizeGame)

    property color topColor: Utils.mixColors(colorManager.tileColor1, colorManager.tileColor2, goalX / gridSizeGame)
    property color bottomColor: Utils.mixColors(colorManager.tileColor3, colorManager.tileColor4, goalX / gridSizeGame)
    property color tileColor: Utils.mixColors(topColor, bottomColor, goalY)
    property color darkTileColor: Qt.darker(tileColor, 1.1)
    property color lightTileColor: Qt.lighter(tileColor, 1.1)

    property real tileMargins: constants.defaultMargins / 2
    property int tileFontSize: width / 3
    property int innerCircleSize: width / 1.75

    x: width * currentX
    y: height * currentY

    AppPaper {
        id: innerRect
        background.color: tileIndex === tileValue ? tileColor : "white"
        anchors { fill: parent; margins: tileMargins }
        elevated: false
        shadowSizeDefault: dp(2)
        radius: constants.defaultRadius

        Behavior on background.color { ColorAnimation { duration: constants.animationsDuration } }

        Rectangle {
            anchors.centerIn: parent
            width: innerCircleSize
            height: innerCircleSize
            color: "#22ffffff"
            radius: width / 2
        }

        Text {
            id: innerRectText
            anchors.centerIn: innerRect
            color: "#aa000000"
            font.bold: true
            font.pixelSize: tileFontSize
            text: tileValue + 1
            z: 2
        }
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
