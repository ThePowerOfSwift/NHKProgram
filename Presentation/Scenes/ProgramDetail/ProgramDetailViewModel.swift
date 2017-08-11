import Foundation

import RxSwift
import RxCocoa
import SwiftDate

import Domain

public final class ProgramDetailViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
    }
    struct Output {
        let isLoading: Driver<Bool>
        let isImageLoading: Driver<Bool>
        let program: Driver<Program?>
        let programTitle: Driver<String>
        let programLogoImage: Driver<UIImage?>
    }
    struct State {
        let isLoading = Variable<Bool>(false)
        let startTimeData = Variable<RightDetailTableViewCell.Data>(.init(title: "開始時刻", rightText: ""))
        let endTimeData = Variable<RightDetailTableViewCell.Data>(.init(title: "終了時刻", rightText: ""))
        let subtitleData = Variable<RightDetailTableViewCell.Data>(.init(title: "サブタイトル", rightText: ""))
        let contentData = Variable<RightDetailTableViewCell.Data>(.init(title: "内容", rightText: ""))
    }
    
    private let bag = DisposeBag()
    
    private let programDetailUseCase: ProgramDetailUseCaseInterface
    private let navigator: ProgramDetailNavigator
    
    let state = State()
    
    public init(
        for id: String,
        with programDetailUseCaseFactory: Factory<ProgramDetailUseCaseInterface>.From<String>,
        with navigator: ProgramDetailNavigator)
    {
        self.programDetailUseCase = programDetailUseCaseFactory.create(id)
        self.navigator = navigator
    }
    
    func transform(from input: Input) -> Output {
        input.load.drive(onNext: programDetailUseCase.fetchProgramDetail).disposed(by: bag)
        
        let isLoading = programDetailUseCase.isLoading.asDriverOnErrorJustComplete()
        isLoading.drive(state.isLoading).disposed(by: bag)
        
        let isImageLoading = programDetailUseCase.isImageLoading.asDriverOnErrorJustComplete()
        
        let program = programDetailUseCase.program.asDriverOnErrorJustComplete().debug()
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMddhhmmss", options: 0, locale: Locale.current)
        
        program
            .filterNil()
            .map { RightDetailTableViewCell.Data(title: "開始時刻", rightText: formatter.string(from: $0.startTime)) }
            .drive(state.startTimeData)
            .disposed(by: bag)
        program
            .filterNil()
            .map { RightDetailTableViewCell.Data(title: "終了時刻", rightText: formatter.string(from: $0.endTime)) }
            .drive(state.endTimeData)
            .disposed(by: bag)
        program
            .filterNil()
            .map { RightDetailTableViewCell.Data(title: "サブタイトル", rightText: $0.subtitle) }
            .drive(state.subtitleData)
            .disposed(by: bag)
        program
            .filterNil()
            .map { RightDetailTableViewCell.Data(title: "内容", rightText: $0.content ?? "") }
            .drive(state.contentData)
            .disposed(by: bag)
        
        let programTitle = Driver.combineLatest(program, isLoading) { program, isLoading in isLoading ? "読み込み中・・・" : (program?.title ?? "") }
        
        let programLogoImage = programDetailUseCase.imageData.map { $0.flatMap(UIImage.init) }.asDriverOnErrorJustComplete()
        
        return Output(isLoading: isLoading, isImageLoading: isImageLoading, program: program, programTitle: programTitle, programLogoImage: programLogoImage)
    }
}
