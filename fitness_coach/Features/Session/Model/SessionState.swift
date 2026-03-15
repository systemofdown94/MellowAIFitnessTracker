enum SessionState: Equatable {
    case noActive
    case active(Session)
    case pause(Session)
}
