import Foundation

import RxSwift
import RxCocoa

public protocol ProgramDetailUseCaseInterface: class {
    var program: Observable<Program> { get }
    var isLoading: Observable<Bool> { get }
    var imageData: Observable<Data?> { get }
    var isImageLoading: Observable<Bool> { get }
    func fetchProgramDetail()
}

public final class ProgramDetailUseCase: ProgramDetailUseCaseInterface {
    private let bag = DisposeBag()
    
    private let id: String
    private let programRepository: ProgramRepositoryInterface
    private let imageRepository: ImageRepositoryInterface
    
    public init(for id: String, with programRepository: ProgramRepositoryInterface, with imageRepository: ImageRepositoryInterface) {
        self.id = id
        self.programRepository = programRepository
        self.imageRepository = imageRepository
    }
    
    private let _program = PublishSubject<Program>()
    public var program: Observable<Program> { return _program }
    
    private let _isLoading = BehaviorSubject<Bool>(value: false)
    public var isLoading: Observable<Bool> { return _isLoading }
    
    private var _imageData = PublishSubject<Data?>()
    public var imageData: Observable<Data?> { return _imageData }
    
    private var _isImageLoading = BehaviorSubject<Bool>(value: false)
    public var isImageLoading: Observable<Bool> { return _isImageLoading }
    
    public func fetchProgramDetail() {
        _isLoading.on(.next(true))
        programRepository.loadProgram(id: id).subscribe(onNext: programDidFetch, onError: { print("Error: \($0)") }).disposed(by: bag)
    }
    
    private func programDidFetch(_ program: Program) {
        _isLoading.on(.next(false))
        _program.on(.next(program))
        if let logoImageURL = program.logoImageURL {
            _isImageLoading.on(.next(true))
            imageRepository.loadImageData(from: logoImageURL)
                .subscribe(onNext: imageDidLoad, onError: { print("Error: \($0)") })
                .disposed(by: bag)
        }
    }
    
    private func imageDidLoad(_ data: Data) {
        _isImageLoading.on(.next(false))
        _imageData.on(.next(data))
    }
}
