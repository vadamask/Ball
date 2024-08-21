import Foundation

final class AchievementsService {
    static let shared = AchievementsService()
    
    private var storage: [Achievement] = []
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func initialize() {
        let achievements: [Achievement] = [
            Achievement(id: 1, description: "Levels 1-10 successfully completed", isLocked: true),
            Achievement(id: 2, description: "Levels 11-20 successfully completed", isLocked: true),
            Achievement(id: 3, description: "Levels 21-30 successfully completed", isLocked: true),
            Achievement(id: 4, description: "Levels 31-40 successfully completed", isLocked: true),
            Achievement(id: 5, description: "Levels 41-50 successfully completed", isLocked: true),
            Achievement(id: 6, description: "Levels 51-60 successfully completed", isLocked: true),
            Achievement(id: 7, description: "Levels 61-70 successfully completed", isLocked: true),
            Achievement(id: 8, description: "Levels 71-80 successfully completed", isLocked: true),
            Achievement(id: 9, description: "Levels 81-90 successfully completed", isLocked: true),
            Achievement(id: 10, description: "Levels 91-100 successfully completed", isLocked: true)
        ]
        saveAchievements(achievements)
    }
    
    func getAchievements() -> [Achievement] {
        if let data = userDefaults.data(forKey: "achievements") {
            do {
                return try PropertyListDecoder().decode([Achievement].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    func unlock(id: Int) {
        var achievements = getAchievements()
        if let index = achievements.firstIndex(where: { $0.id == id }) {
            let achievement = achievements[index]
            achievements[index] = Achievement(id: id, description: achievement.description, isLocked: false)
            saveAchievements(achievements)
        }
    }
    
    func achievement(by id: Int) -> Achievement? {
        if let data = userDefaults.data(forKey: "achievements") {
            do {
                return try PropertyListDecoder().decode([Achievement].self, from: data).first { $0.id == id }
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func saveAchievements(_ achievements: [Achievement]) {
        do {
            let data = try PropertyListEncoder().encode(achievements)
            userDefaults.setValue(data, forKey: "achievements")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
