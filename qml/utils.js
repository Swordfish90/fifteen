/**
 * Shuffles array in place.
 * @param {Array} a items An array containing the items.
 */
function shuffle(a) {
    var j, x, i;
    for (i = a.length - 1; i > 0; i--) {
        j = Math.floor(Math.random() * (i + 1));
        x = a[i];
        a[i] = a[j];
        a[j] = x;
    }
    return a;
}

function swap(array, i, j) {
    var temp = array[i]
    array[i] = array[j]
    array[j] = temp
}

function isSorted(array, start, end) {
    for (var i = start; i < end; i++) {
        if (array[i] > array[i+1]) {
            return false;
        }
    }
    return true
}

function mixColors(c1, c2, alpha){
    return Qt.rgba(c1.r * (1 - alpha) + c2.r * alpha,
                   c1.g * (1 - alpha) + c2.g * alpha,
                   c1.b * (1 - alpha) + c2.b * alpha,
                   c1.a * (1 - alpha) + c2.a * alpha)
}
