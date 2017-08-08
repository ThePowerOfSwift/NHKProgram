import Foundation

import RxSwift
import RxCocoa

import Domain

public final class ProgramListNavigator {
    
    private weak var viewController: ProgramListTableViewController?
    
    public init(with viewController: ProgramListTableViewController) {
        self.viewController = viewController
    }
    
    func toProgramDetail(program: Program) {
        viewController?.performSegue(withIdentifier: R.segue.programListTableViewController.toProgram, sender: program)
    }
}
