import Foundation

final class SkinsService {
    
    static let shared = SkinsService()
    private let userDefaults = UserDefaults.standard
    
    private init(){}
    
    func initialize() {
        var skins: [Skin] = []
        
        for i in 1...20 {
            skins.append(Skin(id: i, imageName: "Ball.scnassets/texture\(i).png", price: 15, isBuyed: false, isChoosen: false))
        }
        skins[0] = Skin(id: 1, imageName: "Ball.scnassets/texture\(1).png", price: 15, isBuyed: true, isChoosen: true)
        saveSkins(skins)
    }
    
    func getSkins() -> [Skin] {
        if let data = userDefaults.data(forKey: "skins") {
            do {
                return try PropertyListDecoder().decode([Skin].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    func getChoosenSkin() -> String {
        let skins = getSkins()
        return skins.first(where: { $0.isChoosen })!.imageName
    }
    
    func buySkin(id: Int) {
        var skins = getSkins()
        let skin = skins[id-1]
        skins[id-1] = Skin(id: skin.id, imageName: skin.imageName, price: skin.price, isBuyed: true, isChoosen: false)
        saveSkins(skins)
        setChoosen(skin.id)
    }
    
    func setChoosen(_ id: Int) {
        var skins = getSkins()
        let choosen = skins.first(where: { $0.isChoosen })!
        let newChoosen = skins[id-1]
        
        skins[choosen.id - 1] = Skin(id: choosen.id, imageName: choosen.imageName, price: choosen.price, isBuyed: choosen.isBuyed, isChoosen: false)
        skins[id-1] = Skin(id: newChoosen.id, imageName: newChoosen.imageName, price: newChoosen.price, isBuyed: newChoosen.isBuyed, isChoosen: true)
        saveSkins(skins)
    }
    
    private func saveSkins(_ skins: [Skin]) {
        do {
            let data = try PropertyListEncoder().encode(skins)
            userDefaults.setValue(data, forKey: "skins")
        } catch {
            print(error.localizedDescription)
        }
    }
}
