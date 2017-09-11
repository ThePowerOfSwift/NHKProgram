import Foundation

import RxSwift
import RxCocoa
import SwiftDate

public protocol ProgramRepositoryInterface: class {
    func loadDailyProgramList(year: Int, month: Int, day: Int) -> Observable<[Program]>
}
