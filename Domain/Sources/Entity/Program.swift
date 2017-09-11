import Foundation

public struct Program {
    public var id: String
    public var title: String
    public var subtitle: String
    public var content: String?
    public var startTime: Date
    public var endTime: Date
    public var logoImageURL: URL?
    
    public init(
        id: String,
        title: String,
        subtitle: String,
        content: String?,
        startTime: Date,
        endTime: Date,
        logoImageURL: URL?)
    {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.startTime = startTime
        self.endTime = endTime
        self.logoImageURL = logoImageURL
    }
}
