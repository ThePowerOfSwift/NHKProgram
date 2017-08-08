import Foundation

import RxSwift
import RxCocoa

public final class ProgramDetailViewModel: ViewModel {
    struct Input {
        
    }
    struct Output {
        
    }
    
    private let navigator: ProgramDetailNavigator
    
    public init(with navigator: ProgramDetailNavigator) {
        self.navigator = navigator
    }
    
    func transform(from input: Input) -> Output {
        fatalError()
    }
}
