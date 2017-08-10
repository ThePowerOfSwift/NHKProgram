import RxSwift

public protocol ProgramRepositoryInterface: class {
    func loadProgram(id: String) -> Observable<Program>
    func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]>
}
