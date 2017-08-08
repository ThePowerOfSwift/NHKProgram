import RxSwift

public protocol ProgramRepositoryInterface: class {
    func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]>
}
