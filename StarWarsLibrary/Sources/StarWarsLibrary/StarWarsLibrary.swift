// The Swift Programming Language
// https://docs.swift.org/swift-book

extension Fetchable: Identifiable {
    public var id: String {
        displayName()
    }
}
