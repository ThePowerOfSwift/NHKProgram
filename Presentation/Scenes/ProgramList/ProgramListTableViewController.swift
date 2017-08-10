import UIKit

import RxSwift
import RxCocoa
import SwiftDate

import Domain

public final class ProgramListTableViewController: UITableViewController {
    private let bag = DisposeBag()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    public var viewModel: ProgramListViewModel! = nil
    
    public override func viewDidLoad() {
        tableView.register(R.nib.programTableViewCell)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProgramListViewModel.Input(refresh: refreshButton.rx.tap.asDriver(), showDetail: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(from: input)
        output.sceneTitle.drive(onNext: sceneTitleDidChange).disposed(by: bag)
        output.todayProgramList.drive(onNext: programsDidLoad).disposed(by: bag)
        output.currentProgramIndex.drive(onNext: currentProgramIndexDidChanged).disposed(by: bag)
        output.detailShown.drive().disposed(by: bag)
        output.refreshed.drive().disposed(by: bag)
    }
    
    private func sceneTitleDidChange(_ title: String) {
        navigationItem.title = title
    }
    
    private func programsDidLoad(_ programs: [Program]) {
        tableView.reloadData()
        if let currentProgramIndex = programs.enumerated().prefix(while: { i, p in p.startTime < Date() }).map({ $0.offset }).last {
            tableView.scrollToRow(at: IndexPath(row: currentProgramIndex, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    private func currentProgramIndexDidChanged(_ index: Int?) {
        
    }
    
    // MARK: - Table View Delegate
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table View Data Source
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.programsViewData.value.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.programTableViewCell, for: indexPath)!
        let program = viewModel.state.programsViewData.asDriver().map { $0[indexPath.row] }
        program.drive(cell.data).disposed(by: cell.subscriptionBag)
        
        return cell
    }
}
