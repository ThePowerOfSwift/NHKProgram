import Foundation

import RxSwift
import RxCocoa

public extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? { return self }
}

public extension ObservableType where E: OptionalType {
    public func filterNil() -> Observable<E.Wrapped> {
        return self.asObservable().flatMap { e -> Observable<E.Wrapped> in
            guard let value = e.value else {
                return Observable.empty()
            }
            return Observable.just(value)
        }
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: OptionalType {
    public func filterNil() -> Driver<E.Wrapped> {
        return self.flatMap { e -> Driver<E.Wrapped> in
            guard let value = e.value else {
                return Driver.empty()
            }
            return Driver.just(value)
        }
    }
}

public extension SharedSequenceConvertibleType {
    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

public extension ObservableType {
    
    public func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    public func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
    
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
