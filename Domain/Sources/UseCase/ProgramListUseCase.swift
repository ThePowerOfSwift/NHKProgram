import Foundation

import RxSwift
import RxCocoa
import SwiftDate

public protocol ProgramListUseCaseInterface: class {
    var todayProgramList: Observable<[Program]> { get }
    
    func fetchTodayProgramList()
}

public class ProgramListUseCase: ProgramListUseCaseInterface {
    
    private let programRepository: ProgramRepositoryInterface
    
    private let bag = DisposeBag()
    
    public init(programRepository: ProgramRepositoryInterface) {
        self.programRepository = programRepository
    }
    
    private let _todayProgramList = BehaviorSubject<[Program]>(value: [])
    public var todayProgramList: Observable<[Program]> { return _todayProgramList }
    
    public func fetchTodayProgramList() {
        let today = Date()
        let y = today.year, m = today.month, d = today.day
        
        programRepository.loadDailyProgramList(year: y, month: m, day: d)
            .subscribe(onNext: _todayProgramList.onNext,
                       onError: { print("An error occured: \($0)") })
            .disposed(by: bag)
    }
}
