import UIKit

import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

import Presentation
import Domain
import Data

extension SwinjectStoryboard {
    // swiftlint:disable function_body_length
    public static func setup() {
        let c = defaultContainer
        
        // Config
        c.register(NHKProgramRepository.Area.self) { _ in NHKProgramRepository.Area.大阪 }
        c.register(NHKProgramRepository.Service.self) { _ in NHKProgramRepository.Service.nhkGeneral1 }
        
        // UIKit
        c.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        c.storyboardInitCompleted(UIViewController.self) { _, _ in }
        c.storyboardInitCompleted(UITableViewController.self) { _, _ in }
        c.storyboardInitCompleted(UITabBarController.self) { _, _ in }
        
        
        // ViewController
        c.storyboardInitCompleted(ProgramListTableViewController.self) { r, vc in
            vc.viewModel = ProgramListViewModel(with: r.resolve(ProgramListUseCaseInterface.self)!, with: ProgramListNavigator(with: vc))
        }
        
        // UseCase
        c.autoregister(ProgramListUseCaseInterface.self, initializer: ProgramListUseCase.init).inObjectScope(.container)
        
        
        // Repository
        c.autoregister(ProgramRepositoryInterface.self, initializer: NHKProgramRepository.init)
        
    }
}
