import Foundation

import RxSwift
import RxCocoa

import Domain

public final class ProgramDetailNavigator {
    
    private weak var viewController: ProgramDetailViewController?
    
    public init(with viewController: ProgramDetailViewController) {
        self.viewController = viewController
    }
    
    func toProgramDetail(program: Program) {
        //        viewController?.performSegue(withIdentifier: R.segue., sender: <#T##Any?#>)
    }
}
