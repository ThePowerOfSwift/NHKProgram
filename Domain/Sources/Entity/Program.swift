import Foundation

public struct Program {
    public var id: String
    public var startTime: Date
    public var endTime: Date
    public var title: String
    public var subtitle: String
    
    public init(id: String, startTime: Date, endTime: Date, title: String, subtitle: String) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.subtitle = subtitle
    }
}
