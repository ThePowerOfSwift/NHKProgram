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
        c.storyboardInitCompleted(ProgramDetailTableViewController.self) { r, vc in
            vc.viewModelFactory = Factory<ProgramDetailViewModel>.From<String> { id in
                ProgramDetailViewModel(
                    for: id,
                    with: r.resolve(Factory<ProgramDetailUseCaseInterface>.From<String>.self)!,
                    with: ProgramDetailNavigator(with: vc)
                )
            }
        }
        
        // UseCase
        c.register(Factory<ProgramDetailUseCaseInterface>.From<String>.self) { r in
            Factory<ProgramDetailUseCaseInterface>.From<String>(factoryMethod: { id in
                ProgramDetailUseCase(
                    for: id,
                    with: r.resolve(ProgramRepositoryInterface.self)!,
                    with: r.resolve(ImageRepositoryInterface.self)!
                )
            })
        }
        c.autoregister(ProgramListUseCaseInterface.self, initializer: ProgramListUseCase.init).inObjectScope(.container)
        
        
        // Repository
        c.autoregister(ProgramRepositoryInterface.self, initializer: NHKProgramRepository.init)
        c.autoregister(ImageRepositoryInterface.self, initializer: FoundationImageRepository.init)
        
    }
}
