import QtQuick 2.0

import "utils.js" as Utils

QtObject {
    id: logic

    signal modelUpdated(var model)

    readonly property string uninitialized: "uninitialized"
    readonly property string ready: "ready"
    readonly property string running: "running"
    readonly property string finished: "finished"

    property int gridSizeGame
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
        initializeValidModel()
        state = ready
    }

    function initializeValidModel() {
        do {
            model = createRandomModel()
        } while (!isSolvable(model) && !isFinished(model))
    }

    function createRandomModel() {
        var model = []
        for (var i = 0; i < constants.gridSizeGameSquared; i++) {
            model.push(i)
        }
        Utils.shuffle(model)
        return model
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
            if (isFinished(model)) {
                state = finished
            }
        }
    }

    function isEmpty(x, y) {
        return model[coordsToIndex(x, y)] === 0
    }

    function coordsToIndex(x, y) {
        return x + y * gridSizeGame
    }

    function move(x, y, dx, dy) {
        if (state !== running && state !== ready)
            return false

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

    function isFinished(model) {
        return Utils.isSorted(model, 0, model.length - 2) && model[model.length - 1] === 0
    }

    /* Not every fifteen puzzle can be solved. It needs to have an odd or even amount of inversions,
     * depending on grid size and the empty tile position.
     * More infos at: https://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html
     */
    function isSolvable(model) {
        var inversions = countInversions(model)
        var blankIndex = retrieveBlankIndex(model)
        var emptyRow = gridSizeGame - Math.floor(blankIndex / gridSizeGame)

        if (gridSizeGame % 2 === 0) {
            return emptyRow % 2 === 0 ? inversions % 2 === 0 : inversions % 2 !== 0
        } else {
            return inversions % 2 === 0
        }
    }

    function retrieveBlankIndex(model) {
        for (var i = 0; i < model.length; i++) {
            if (model[i] === 0) {
                return i
            }
        }
    }

    function countInversions(model) {
        var result = 0
        for (var i = 0; i < model.length; i++) {
            for (var j = i + 1; j < model.length; j++) {
                if (model[i] !== 0 && model[j] !== 0 && model[j] > model[i])
                    result++
            }
        }
        return result
    }
}
