import QtQuick 2.0

QtObject {
    property color foregroundColor: "black"
    property color foregroundColorTransparent: "#22000000"
    property color backgroundColor: "white"
    property color backgroundColorDarker: "#dadada"

    property real cellMaxSize: dp(96)

    property real defaultMargins: dp(7)
    property real defaultRadius: dp(7)

    property string leaderboardBaseName: "fifteen_leaderboard_"

    property real animationsDuration: 125
}
