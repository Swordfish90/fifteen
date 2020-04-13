import QtQuick 2.0

QtObject {
    id: colorManager

    property real value: 1.0
    property real saturation: 0.6

    property real hue: 0.65
    property real hueSpread: 0.1

    // Tile colors are interpolated using these 4 bases.
    property color tileColor1: Qt.hsva(hue + 0 * hueSpread % 1, saturation, value, 1.0)
    property color tileColor2: Qt.hsva(hue + 1 * hueSpread % 1, saturation, value, 1.0)
    property color tileColor3: Qt.hsva(hue + 1 * hueSpread % 1, saturation, value, 1.0)
    property color tileColor4: Qt.hsva(hue + 2 * hueSpread % 1, saturation, value, 1.0)

    function updateColors() {
        colorManager.hue = Math.random()
    }
}
