import Foundation

final class UDService {
    
    static let shared = UDService()
    
    private let storage: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        storage: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.storage = storage
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func value<T: Codable>(forKey key: UDKeys, as type: T.Type) async -> T? {
        guard let data = storage.data(forKey: key.rawValue) else {
            return nil
        }
        
        do {
            return try decoder.decode(type, from: data)
        } catch {
            return nil
        }
    }
    
    func set<T: Codable>(_ value: T, forKey key: UDKeys) async {
        do {
            let data = try encoder.encode(value)
            storage.set(data, forKey: key.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeValue(forKey key: UDKeys) {
        storage.removeObject(forKey: key.rawValue)
    }
}

//

enum UDKeys: String {
    case session
    case profile
}
