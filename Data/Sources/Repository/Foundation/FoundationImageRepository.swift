import Foundation

import RxSwift
import RxCocoa

import Domain

public final class FoundationImageRepository: ImageRepositoryInterface {
    
    public init() {}
    
    public func loadImageData(from url: URL) -> Observable<Data> {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return session.rx.data(request: URLRequest(url: url))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
