import Foundation

import RxSwift
import RxCocoa

import Domain

public final class ProgramListViewModel: ViewModel {
    struct Input {
        let refresh: Driver<Void>
        let showDetail: Driver<Program>
    }
    struct Output {
        let todayProgramList: Driver<[Program]>
        let refreshed: Driver<Void>
        let detailShown: Driver<Void>
    }
    
    private let programListUseCase: ProgramListUseCaseInterface
    private let navigator: ProgramListNavigator
    
    public init(with programListUseCase: ProgramListUseCaseInterface, with navigator: ProgramListNavigator) {
        self.programListUseCase = programListUseCase
        self.navigator = navigator
    }
    
    func transform(from input: Input) -> Output {
        let todayProgramList = programListUseCase.todayProgramList
        input.refresh.do(onNext: { [weak self] in
            guard let s = self else { return }
            s.programListUseCase.fetchTodayProgramList()
        })
        fatalError()
    }
}
