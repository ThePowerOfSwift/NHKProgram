import UIKit

import RxSwift
import RxCocoa

import Domain

public final class ProgramDetailTableViewController: UITableViewController {
    private let bag = DisposeBag()
    
    @IBOutlet var headerView: UIVisualEffectView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: ProgramDetailViewModel!
    public var viewModelFactory: Factory<ProgramDetailViewModel>.From<String>!
    
    public override func viewDidLoad() {
        assert(self.viewModel != nil)
        super.viewDidLoad()
        
        tableView.register(R.nib.rightDetailTableViewCell)
        tableView.tableHeaderView = headerView
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProgramDetailViewModel.Input(load: Driver.just())
        let output = viewModel.transform(from: input)
        
        output.isLoading.drive().disposed(by: bag)
        output.program.drive(onNext: programDidChange).disposed(by: bag)
        output.programTitle.drive(titleLabel.rx.text).disposed(by: bag)
        output.programLogoImage.drive(logoImageView.rx.image).disposed(by: bag)
    }
    
    private func programDidChange(_ program: Program) {
        tableView.reloadData()
    }
    
    public func set(id: String) {
        viewModel = viewModelFactory.create(id)
    }
    
    // MARK: UIScrollViewDelegate
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = tableView.tableHeaderView else { return }
        tableView.layoutIfNeeded()
        headerView.frame.origin.y += tableView.contentInset.top + tableView.contentOffset.y
    }
    
    // MARK: - UITableViewDelegate
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - UITableViewDataSource
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.isLoading.value ? 0 : 4
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.rightDetailTableViewCell, for: indexPath)!
        
        let driver: Driver<RightDetailTableViewCell.Data>
        
        switch indexPath.row {
        case 0: driver = viewModel.state.startTimeData.asDriver()
        case 1: driver = viewModel.state.endTimeData.asDriver()
        case 2: driver = viewModel.state.subtitleData.asDriver()
        case 3: driver = viewModel.state.contentData.asDriver()
        default: fatalError()
        }
        
        driver.drive(cell.data).disposed(by: cell.subscriptionBag)
        
        return cell
    }
}
