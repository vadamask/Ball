import Foundation

final class LevelsService {
    
    static let shared = LevelsService()
    private let userDefaults = UserDefaults.standard
    
    var starsCount: Int {
        get {
            userDefaults.integer(forKey: "stars")
        }
        set {
            userDefaults.setValue(newValue, forKey: "stars")
        }
    }
    
    func initialize() {
        var levels: [Level] = []
        for i in 1...100 {
            levels.append(Level(id: i, isLocked: true, rating: 0, records: []))
        }
        levels[0] = Level(id: 1, isLocked: false, rating: 0, records: generateRandomRecords())
        
        do {
            let data = try PropertyListEncoder().encode(levels)
            userDefaults.setValue(data, forKey: "levels")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getLevels() -> [Level] {
        if let data = userDefaults.data(forKey: "levels") {
            do {
                return try PropertyListDecoder().decode([Level].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    func saveResult(_ id: Int, time: Int, rating: Int) {
        if id == 10 {
            AchievementsService.shared.unlock(id: 1)
        } else if id == 20 {
            AchievementsService.shared.unlock(id: 2)
        } else if id == 30 {
            AchievementsService.shared.unlock(id: 3)
        } else if id == 40 {
            AchievementsService.shared.unlock(id: 4)
        } else if id == 50 {
            AchievementsService.shared.unlock(id: 5)
        } else if id == 60 {
            AchievementsService.shared.unlock(id: 6)
        } else if id == 70 {
            AchievementsService.shared.unlock(id: 7)
        } else if id == 80 {
            AchievementsService.shared.unlock(id: 8)
        } else if id == 90 {
            AchievementsService.shared.unlock(id: 9)
        } else if id == 100 {
            AchievementsService.shared.unlock(id: 10)
        }
        
        var levels = getLevels()
        let level = levels[id-1]
        var records = level.records
        records.append(Record(
            id: records.count + 1,
            time: time,
            date: Date(),
            player: Player(id: 0, name: UserDefaults.standard.string(forKey: "username") ?? "Player")
        ))
        levels[id-1] = Level(id: level.id, isLocked: level.isLocked, rating: rating, records: records)
        saveLevels(levels)
        unlockNextIfNeeded(id: level.id + 1)
        starsCount += rating
    }
    
    func level(by id: Int) -> Level {
        getLevels()[id-1]
    }
    
    func getBestResult(_ id: Int) -> Record {
        let level = getLevels()[id-1]
        return level.bestResult
    }
    
    private func saveLevels(_ levels: [Level]) {
        do {
            let data = try PropertyListEncoder().encode(levels)
            userDefaults.setValue(data, forKey: "levels")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func unlockNextIfNeeded(id: Int) {
        var levels = getLevels()
        let level = levels[id-1]
        if level.isLocked {
            levels[id-1] = Level(id: level.id, isLocked: false, rating: 0, records: generateRandomRecords())
            saveLevels(levels)
        }
    }
}

// MARK: - Mock records

extension LevelsService {
    private func generateRandomRecords() -> [Record] {
        var records = [Record]()

        for i in 1...20 {
            let time = Int.random(in: 10...20)
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            let player = players.randomElement()!
            let record = Record(id: i, time: time, date: date, player: player)
            records.append(record)
        }
        return records
    }
}

fileprivate let players: [Player] = [
    Player(id: 1, name: "Alice"),
    Player(id: 2, name: "Bob"),
    Player(id: 3, name: "Charlie"),
    Player(id: 4, name: "David"),
    Player(id: 5, name: "Eve"),
    Player(id: 6, name: "Frank"),
    Player(id: 7, name: "Grace"),
    Player(id: 8, name: "Hannah"),
    Player(id: 9, name: "Isaac"),
    Player(id: 10, name: "Jack"),
    Player(id: 11, name: "Katherine"),
    Player(id: 12, name: "Liam"),
    Player(id: 13, name: "Mia"),
    Player(id: 14, name: "Nathan"),
    Player(id: 15, name: "Olivia"),
    Player(id: 16, name: "Paul"),
    Player(id: 17, name: "Quincy"),
    Player(id: 18, name: "Rachel"),
    Player(id: 19, name: "Samuel"),
    Player(id: 20, name: "Tina"),
    Player(id: 21, name: "Uma"),
    Player(id: 22, name: "Victor"),
    Player(id: 23, name: "Wendy"),
    Player(id: 24, name: "Xavier"),
    Player(id: 25, name: "Yvonne"),
    Player(id: 26, name: "Zachary"),
    Player(id: 27, name: "Ava"),
    Player(id: 28, name: "Benjamin"),
    Player(id: 29, name: "Chloe"),
    Player(id: 30, name: "Daniel"),
    Player(id: 31, name: "Elena"),
    Player(id: 32, name: "Felix"),
    Player(id: 33, name: "Georgia"),
    Player(id: 34, name: "Henry"),
    Player(id: 35, name: "Ivy"),
    Player(id: 36, name: "James"),
    Player(id: 37, name: "Kara"),
    Player(id: 38, name: "Leo"),
    Player(id: 39, name: "Megan"),
    Player(id: 40, name: "Noah"),
    Player(id: 41, name: "Olga"),
    Player(id: 42, name: "Peter"),
    Player(id: 43, name: "Quinn"),
    Player(id: 44, name: "Rose"),
    Player(id: 45, name: "Steven"),
    Player(id: 46, name: "Tara"),
    Player(id: 47, name: "Ulysses"),
    Player(id: 48, name: "Vera"),
    Player(id: 49, name: "Will"),
    Player(id: 50, name: "Xena"),
    Player(id: 51, name: "Yara"),
    Player(id: 52, name: "Zane"),
    Player(id: 53, name: "Abigail"),
    Player(id: 54, name: "Blake"),
    Player(id: 55, name: "Charlotte"),
    Player(id: 56, name: "Dylan"),
    Player(id: 57, name: "Emma"),
    Player(id: 58, name: "Finn"),
    Player(id: 59, name: "Gavin"),
    Player(id: 60, name: "Harper"),
    Player(id: 61, name: "Ian"),
    Player(id: 62, name: "Julia"),
    Player(id: 63, name: "Kevin"),
    Player(id: 64, name: "Lily"),
    Player(id: 65, name: "Mason"),
    Player(id: 66, name: "Nina"),
    Player(id: 67, name: "Oscar"),
    Player(id: 68, name: "Paula"),
    Player(id: 69, name: "Quinton"),
    Player(id: 70, name: "Rebecca"),
    Player(id: 71, name: "Scott"),
    Player(id: 72, name: "Tracy"),
    Player(id: 73, name: "Ulrich"),
    Player(id: 74, name: "Violet"),
    Player(id: 75, name: "Wyatt"),
    Player(id: 76, name: "Ximena"),
    Player(id: 77, name: "Yosef"),
    Player(id: 78, name: "Zoey"),
    Player(id: 79, name: "Alex"),
    Player(id: 80, name: "Brianna"),
    Player(id: 81, name: "Cameron"),
    Player(id: 82, name: "Diana"),
    Player(id: 83, name: "Ella"),
    Player(id: 84, name: "Freddie"),
    Player(id: 85, name: "Gabriella"),
    Player(id: 86, name: "Hudson"),
    Player(id: 87, name: "Iris"),
    Player(id: 88, name: "Jasper"),
    Player(id: 89, name: "Kate"),
    Player(id: 90, name: "Lucas"),
    Player(id: 91, name: "Madison"),
    Player(id: 92, name: "Nolan"),
    Player(id: 93, name: "Owen"),
    Player(id: 94, name: "Piper"),
    Player(id: 95, name: "Quinlan"),
    Player(id: 96, name: "Riley"),
    Player(id: 97, name: "Sophia"),
    Player(id: 98, name: "Tyler"),
    Player(id: 99, name: "Ursula"),
    Player(id: 100, name: "Vince")
]
