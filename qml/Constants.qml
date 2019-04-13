import QtQuick 2.0

QtObject {
    property int gridWidth: 300
    property int gridSizeGame: 4
    property int gridSizeGameSquared: gridSizeGame * gridSizeGame

    property color foregroundColor: "#ffffff"
    property color backgroundColor: "#3c4564"
    property color backgroundColorTop: backgroundColor
    property color backgroundColorBottom: Qt.darker(backgroundColorTop, 1.5)

    property color backgroundLight: "#697597"

    property real defaultMargins: 5
    property real defaultRadius: 5

    property real value: 0.9
    property real saturation: 0.5

    // Tile colors are interpolated using these 4 bases.
    property color tileColor1: Qt.hsva(0.65, saturation, value, 1.0)
    property color tileColor2: Qt.hsva(0.73, saturation, value, 1.0)
    property color tileColor3: Qt.hsva(0.73, saturation, value, 1.0)
    property color tileColor4: Qt.hsva(0.85, saturation, value, 1.0)

    property real animationsDuration: 150
}
