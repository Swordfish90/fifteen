import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property alias horizontalBlur: horizontalBlurEffect.visible
    property alias verticalBlur: verticalBlurEffect.visible
    property var source

    DirectionalBlur {
        id: horizontalBlurEffect
        anchors.fill: parent
        source: parent.source
        cached: true
        angle: 90
        length: 5
        samples: 3
        visible: false
    }

    DirectionalBlur {
        id: verticalBlurEffect
        anchors.fill: parent
        source: parent.source
        angle: 0
        cached: true
        length: 5
        samples: 3
        visible: false
    }
}
