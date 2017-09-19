//
//  ProgramListTableViewController.swift
//  NHKProgram
//
//  Created by 原飛雅 on 2017/09/11.
//  Copyright © 2017年 takka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain
import Data
import SwiftDate

class ProgramListTableViewController: UIViewController {
    let disposebag: DisposeBag = DisposeBag()
    
    var model: ProgramListModel!
    
    @IBOutlet weak var refleshBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeModel()
        initializeTableView()
        bind()
    }
    
    
    
    private func initializeModel() {
        self.model = ProgramListModel(programListUsecase: ProgramListUseCase(programRepository: NHKProgramRepository()))
    }
    
    private func initializeTableView(){
        let nib = UINib(nibName: "ProgramTableViewCell", bundle: Bundle(for: ProgramTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "ProgramTableViewCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    private func bind() {
        model.todayProgramList.drive(tableView.rx.items(cellIdentifier: "ProgramTableViewCell", cellType: ProgramTableViewCell.self)) { (row, element, cell) in
            cell.timeLabel.text = "\(element.startTime.hour):\(element.startTime.minute)"
            cell.titleLabel.text = element.title
            cell.contentLabel.text = element.content
            }.disposed(by: disposebag)
        
        refleshBarButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.model.refresh()
            }).disposed(by: disposebag)
    
    }
}
