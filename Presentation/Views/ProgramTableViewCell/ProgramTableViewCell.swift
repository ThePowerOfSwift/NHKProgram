//
//  ProgramTableViewCell.swift
//  NHKProgram
//
//  Created by 原飛雅 on 2017/09/11.
//  Copyright © 2017年 takka. All rights reserved.
//

import UIKit

class ProgramTableViewCell: UITableViewCell {
  
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
