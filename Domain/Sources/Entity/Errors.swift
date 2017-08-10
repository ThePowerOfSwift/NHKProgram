public enum WebAPIError: Error {
    case illegalResponse
    case notFound
    case unknown
}

public enum AppError: Error {
    case illegalArgument
}
