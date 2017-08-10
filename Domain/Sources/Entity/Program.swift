import Foundation

public struct Program {
    public var id: String
    public var startTime: Date
    public var endTime: Date
    public var title: String
    public var subtitle: String
    public var logoImageURL: URL?
    public var content: String?
    
    
    public init(
        id: String,
        startTime: Date,
        endTime: Date,
        title: String,
        subtitle: String,
        logoImageURL: URL? = nil,
        content: String? = nil)
    {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.subtitle = subtitle
        self.logoImageURL = logoImageURL
        self.content = content
    }
}
