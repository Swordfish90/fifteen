import Felgo 3.0
import QtQuick 2.0

import QtQuick 2.2
import Felgo 3.0

Rectangle {
    id: gameBackground
    width: gridWidth
    height: width
    color: "#4A230B"
    radius: 5

    Grid {
        id: tileGrid
        anchors.centerIn: parent
        rows: gridSizeGame

        Repeater {
            id: cells
            model: gridSizeGameSquared

            Item {
                width: gridWidth / gridSizeGame
                height: width

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 2
                    height: width
                    color: "#E99C0A"
                    radius: 4
                }
            }
        }
    }
}
