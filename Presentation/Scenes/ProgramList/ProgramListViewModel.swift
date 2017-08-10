import Foundation

import RxSwift
import RxCocoa
import SwiftDate

import Domain

public final class ProgramListViewModel: ViewModel {
    struct Input {
        let refresh: Driver<Void>
        let showDetail: Driver<IndexPath>
    }
    struct Output {
        let sceneTitle: Driver<String>
        let todayProgramList: Driver<[Program]>
        let currentProgramIndex: Driver<Int?>
        let refreshed: Driver<Void>
        let detailShown: Driver<Void>
    }
    
    struct State {
        let programsViewData = Variable<[ProgramTableViewCell.Data]>([])
    }
    
    private let bag = DisposeBag()
    
    private let programListUseCase: ProgramListUseCaseInterface
    private let navigator: ProgramListNavigator
    
    private(set) var state: State = State()
    
    public init(with programListUseCase: ProgramListUseCaseInterface, with navigator: ProgramListNavigator) {
        self.programListUseCase = programListUseCase
        self.navigator = navigator
    }
    
    func transform(from input: Input) -> Output {
        let sceneTitle = programListUseCase.todayProgramList.map {
            ($0.first?.startTime).map { "\($0.month)月\($0.day)日の番組表" } ?? ""
        }
        
        let todayProgramList = programListUseCase.todayProgramList
        todayProgramList.map { programs in
            let enumeratedPrograms = programs.enumerated()
            let currentProgramIndex = enumeratedPrograms.prefix { i, p in p.startTime < Date() }.map { $0.offset }.last
            return enumeratedPrograms.map { i, p in
                ProgramTableViewCell.Data(
                    startTimeText: String(format: "%02d:%02d -", p.startTime.hour, p.startTime.minute),
                    programTitle: p.title,
                    programDescription: p.subtitle,
                    isEmphasized: currentProgramIndex == i
                )
            }
        }.bind(to: state.programsViewData).disposed(by: bag)
        
        
        let currentProgramIndex = programListUseCase.currentProgramIndex.do(onNext: { [weak self] index in
            guard let index = index else { return }
            guard let programsViewData = self?.state.programsViewData.value
                .enumerated()
                .forEachMutating({ $0.element.isEmphasized = $0.offset == index })
                .map({ $0.element }) else { return }
            self?.state.programsViewData.value = programsViewData
        })
        
        let refreshed = input.refresh.do(onNext: { [weak self] in
            guard let s = self else { return }
            s.programListUseCase.fetchTodayProgramList()
        })
        
        let detailShown = input.showDetail
            .withLatestFrom(todayProgramList.asDriverOnErrorJustComplete()) { ($0, $1) }
            .do(onNext: { [weak self] indexPath, programs in
                self?.navigator.toProgramDetail(program: programs[indexPath.row])
        }).mapToVoid()
        
        return Output(
            sceneTitle: sceneTitle.asDriverOnErrorJustComplete(),
            todayProgramList: todayProgramList.asDriverOnErrorJustComplete(),
            currentProgramIndex: currentProgramIndex.asDriverOnErrorJustComplete(),
            refreshed: refreshed,
            detailShown: detailShown
        )
    }
}
