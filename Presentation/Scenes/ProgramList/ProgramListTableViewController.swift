import UIKit

import RxSwift
import RxCocoa

import Domain

public final class ProgramListTableViewController: UITableViewController {
    private let bag = DisposeBag()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    public var viewModel: ProgramListViewModel! = nil
    
    public override func viewDidLoad() {
        tableView.register(R.nib.programTableViewCell)
        
        
        
    }
    
    private func bindViewModel() {
        
    }
}
