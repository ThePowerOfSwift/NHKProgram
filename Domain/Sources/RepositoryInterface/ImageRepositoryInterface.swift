import RxSwift

public protocol ImageRepositoryInterface: class {
    func loadImageData(from url: URL) -> Observable<Data>
}
