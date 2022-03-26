import Foundation

enum Errors: LocalizedError {
    case titleNotFound
    
    var errorDescription: String? {
        switch self {
        case .titleNotFound:
            return "Заголовок не найден"
        }
    }
}
