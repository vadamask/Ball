import Foundation

// от слова Resources для картинок

enum R {
    enum Button: String {
        
        // квадратные
        
        case menuSquare = "menuButtonSquare"
        case pause = "pauseButton"
        case play = "playButton"
        case down = "downButton"
        case left = "leftButton"
        case right = "rightButton"
        
        // прямоугольные
        
        case playRect = "playButtonRect"
        case selectLevel = "selectLevelButtonRect"
        case tutorial = "tutorialButtonRect"
        case profile = "profileButtonRect"
        case store = "storeButtonRect"
        case privacy = "privacyButtonRect"
        case next = "nextButtonRect"
        case again = "againButtonRect"
        case stat = "statButtonRect"
        case back = "backButtonRect"
        case menuRect = "menuButtonRect"
    }
    
    enum Background: String {
        case menu = "menuBackground"
        case game = "gameBackground"
        case result = "resultBackground"
        case map = "mapBackground"
        case midFrame
        case bigFrame
        case skin = "skinBackground"
        case detailLevel = "detailLevelBackground"
    }
    
    enum Label: String {
        case levels = "selectLevelLabel"
        case profile = "profileLabel"
        case achiev = "achievementsLabel"
        case store = "storeLabel"
        case stat = "statisticsLabel"
    }
    
    enum App: String {
        case logo
    }
    
    enum Game: String {
        case lock = "lockLevel"
        case win
        case lose
        case level
    }
    
    enum Icon: String {
        case profile = "profileIcon"
        case balance
        case checkmark
        case star
    }
}
