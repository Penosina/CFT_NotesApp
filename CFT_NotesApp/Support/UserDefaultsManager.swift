import Foundation

final class UserDefaultsManager {
    enum Key: String {
        case id, isFirstEntry
    }
    
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    
    // MARK: - Public Methods
    func getNewId() -> Int {
        let id = defaults.integer(forKey: Key.id.rawValue) + 1
        defaults.set(id + 1, forKey: Key.id.rawValue)
        
        return id
    }
    
    func isFirstEntry() -> Bool {
        defaults.bool(forKey: Key.isFirstEntry.rawValue)
    }
    
    func setFirstEntry() {
        defaults.set(true, forKey: Key.isFirstEntry.rawValue)
        defaults.set(0, forKey: Key.id.rawValue)
    }
}
