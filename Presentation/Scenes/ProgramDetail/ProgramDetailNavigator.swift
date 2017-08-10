import Foundation

import RxSwift
import RxCocoa

import Domain

public final class ProgramDetailNavigator {
    
    private weak var viewController: ProgramDetailTableViewController?
    
    public init(with viewController: ProgramDetailTableViewController) {
        self.viewController = viewController
    }
}
