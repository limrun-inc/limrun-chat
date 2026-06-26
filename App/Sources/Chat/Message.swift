import Foundation

enum Role {
    case user
    case assistant
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    var text: String
    var isStreaming: Bool = false
}
