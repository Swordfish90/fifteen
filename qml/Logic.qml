import QtQuick 2.0

import "utils.js" as Utils

QtObject {
    id: logic

    signal modelUpdated(var model)

    readonly property string uninitialized: "uninitialized"
    readonly property string ready: "ready"
    readonly property string running: "running"
    readonly property string finished: "finished"

    property string state: uninitialized
    property real time: 0
    property var model: new Array(gridSizeGameSquared)

    property Timer timer: Timer {
        running: logic.state === logic.running
        interval: 100
        repeat: true
        onTriggered: time += 0.1
    }

    onStateChanged: console.log("Game state changed", state)

    function restart() {
        state = uninitialized
        time = 0
        initializeModel()
        state = ready
    }

    function initializeModel() {
        model = []
        model.push(empty)
        for (var i = 1; i < gridSizeGameSquared; i++) {
            model.push(i)
        }
        Utils.shuffle(model)
    }

    function onCellClicked(x, y) {
        if (state === ready)
            state = running

        var moved = false
        moved |= move(x, y, 1, 0)
        moved |= move(x, y, -1, 0)
        moved |= move(x, y, 0, 1)
        moved |= move(x, y, 0, -1)

        if (moved) {
            modelUpdated(model)
            if (isFinished()) {
                state = finished
            }
        }
    }

    function isEmpty(x, y) {
        return model[coordsToIndex(x, y)] === empty
    }

    function coordsToIndex(x, y) {
        return x + y * gridSizeGame
    }

    function move(x, y, dx, dy) {
        if (!isInGame(x + dx, y + dy))
            return false

        if (isEmpty(x + dx, y + dy) || move(x + dx, y + dy, dx, dy)) {
            performMoveSwap(x, y, x + dx, y + dy)
            return true
        }
    }

    function performMoveSwap(x1, y1, x2, y2) {
        var fromIndex = coordsToIndex(x1, y1)
        var toIndex = coordsToIndex(x2, y2)
        Utils.swap(model, fromIndex, toIndex)
    }

    function isInGame(x, y) {
        return x >= 0 && x < gridSizeGame && y >= 0 && y < gridSizeGame
    }

    function isFinished() {
        return Utils.isSorted(model, 0, model.length - 2) && model[model.length - 1] === 0
    }
}
