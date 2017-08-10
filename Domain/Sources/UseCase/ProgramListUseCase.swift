import Foundation

import RxSwift
import RxCocoa
import SwiftDate

public protocol ProgramListUseCaseInterface: class {
    var todayProgramList: Observable<[Program]> { get }
    var currentProgramIndex: Observable<Int?> { get }
    func fetchTodayProgramList()
}

public final class ProgramListUseCase: ProgramListUseCaseInterface {
    private let bag = DisposeBag()
    private var timerBag = DisposeBag()
    
    private let programRepository: ProgramRepositoryInterface
    
    public init(with programRepository: ProgramRepositoryInterface) {
        self.programRepository = programRepository
    }
    
    private let _todayProgramList = BehaviorSubject<[Program]>(value: [])
    public var todayProgramList: Observable<[Program]> { return _todayProgramList }
    
    private let _currentProgramIndex = BehaviorSubject<Int?>(value: nil)
    public var currentProgramIndex: Observable<Int?> { return _currentProgramIndex }
    
    public func fetchTodayProgramList() {
        let today = Date()
        let y = today.year, m = today.month, d = today.day
        programRepository
            .loadDailyProgramList(year: y, month: m, day: d)
            .subscribe(onNext: programsDidFetch)
            .disposed(by: bag)
    }
    
    private func programsDidFetch(_ programs: [Program]) {
        timerBag = DisposeBag()
        
        _todayProgramList.onNext(programs)
        
        func currentProgramIndex(in programs: [Program]) -> Int? {
            return programs.enumerated().prefix { i, p in p.startTime < Date() }.map { $0.offset }.last
        }
        
        Observable<Int>.interval(5, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { _ in currentProgramIndex(in: programs) }
            .subscribe(onNext: _currentProgramIndex.onNext)
            .disposed(by: timerBag)
    }
    
}
