//
//  ProgramListModel.swift
//  NHKProgram
//
//  Created by 原飛雅 on 2017/09/11.
//  Copyright © 2017年 takka. All rights reserved.
//

import Foundation
import Data
import Domain
import RxSwift
import RxCocoa

class ProgramListModel {
    private var programListUsecase: ProgramListUseCaseInterface
    init(programListUsecase: ProgramListUseCaseInterface) {
         self.programListUsecase = programListUsecase
    }
    var todayProgramList: Driver<[Program]>  {
        return programListUsecase.todayProgramList.asDriver(onErrorJustReturn: [])
    }
    func refresh(){
        programListUsecase.fetchTodayProgramList()
    }
    
}
