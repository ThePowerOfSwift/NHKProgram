import Foundation

import RxSwift
import RxCocoa

public final class ProgramDetailViewModel: ViewModel {
    struct Input {
        
    }
    struct Output {
        
    }
    struct State {
        
    }
    
    private let navigator: ProgramDetailNavigator
    
    let state = State()
    
    public init(with navigator: ProgramDetailNavigator) {
        self.navigator = navigator
    }
    
    func transform(from input: Input) -> Output {
        fatalError()
    }
}
