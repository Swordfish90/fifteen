import Felgo 3.0
import QtQuick 2.0

App {
    id: gameWindow

    Constants { id: constants }

    ColorManager { id: colorManager }

    FelgoGameNetwork {
        id: gameNetwork
        gameId: 625
        secret: "hNbBRe0my88s14gDMc0BEkG7p42dR0bjiNBHjJInkUQdVQQgfqBINLrLOiZh"
    }

    SocialView {
        id: socialView
        anchors.fill: parent
        gameNetworkItem: gameNetwork
        visible: false
        tintColor: constants.foregroundColor
        tintLightColor: constants.foregroundColorTransparent
    }

    Logic {
        id: logic
        gridSizeGame: 4

        onStateChanged:     {
            if (state === uninitialized) {
                //gameNetwork.reportScore(100000, constants.leaderboardBaseName + logic.gridSizeGame, null, "lowest_is_best")
            } else if (state === finished) {
                gameNetwork.reportScore(logic.time, constants.leaderboardBaseName + logic.gridSizeGame, null, "lowest_is_best")
            }
        }
    }

    onInitTheme: {
        Theme.colors.backgroundColor = constants.backgroundColorDarker
        Theme.navigationBar.backgroundColor = constants.backgroundColor
        Theme.navigationBar.titleColor = constants.foregroundColor
        Theme.navigationBar.dividerColor = "transparent"
        Theme.listItem.dividerColor = constants.backgroundColorDarker

    }

    NavigationStack {
        id: mainNavigation

        MainPage {
            id: mainPage

            title: logic.time.toFixed(1)

            Component.onCompleted: logic.restart()
        }
    }
}
