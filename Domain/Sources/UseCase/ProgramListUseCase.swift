import Foundation

import RxSwift
import RxCocoa
import SwiftDate

public protocol ProgramListUseCaseInterface: class {
    var todayProgramList: Observable<[Program]> { get }
    func fetchTodayProgramList()
}

public final class ProgramListUseCase: ProgramListUseCaseInterface {
    private let bag = DisposeBag()
    
    private let programRepository: ProgramRepositoryInterface
    
    public init(with programRepository: ProgramRepositoryInterface) {
        self.programRepository = programRepository
    }
    
    private let _todayProgramList = BehaviorSubject<[Program]>(value: [])
    public var todayProgramList: Observable<[Program]> { return _todayProgramList }
    
    public func fetchTodayProgramList() {
        let today = Date()
        let y = today.year, m = today.month, d = today.day
        programRepository
            .loadDailyProgramList(year: y, month: m, day: d)
            .bind(to: _todayProgramList)
            .disposed(by: bag)
    }
}
