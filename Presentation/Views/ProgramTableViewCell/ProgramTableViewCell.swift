import UIKit

import RxSwift
import RxCocoa

private let emphasisBackgroundColor = UIColor(displayP3Red: 0xff / 0xff, green: 0xee / 0xff, blue: 0x99 / 0xff, alpha: 1.0)

class ProgramTableViewCell: UITableViewCell {
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    
    private let bag = DisposeBag()
    var subscriptionBag = DisposeBag()
    
    let data = Variable(Data(startTimeText: "00:00", programTitle: "", programDescription: "", isEmphasized: false))
    
    override func awakeFromNib() {
        [startTimeLabel]
            .forEach { $0.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: UIFontWeightRegular) }
        
        initializeRx()
    }
    
    private func initializeRx() {
        let d = data.asDriver()
        d.map { $0.startTimeText }.drive(startTimeLabel.rx.text).disposed(by: bag)
        d.map { $0.programTitle }.drive(programTitleLabel.rx.text).disposed(by: bag)
        d.map { $0.programDescription }.drive(programDescriptionLabel.rx.text).disposed(by: bag)
        d.map { $0.isEmphasized ? emphasisBackgroundColor : .clear }.drive(rx.backgroundColor).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptionBag = DisposeBag()
    }
}

extension ProgramTableViewCell {
    struct Data {
        var startTimeText: String
        var programTitle: String
        var programDescription: String
        var isEmphasized: Bool
        
        init(startTimeText: String, programTitle: String, programDescription: String, isEmphasized: Bool) {
            self.startTimeText = startTimeText
            self.programTitle = programTitle
            self.programDescription = programDescription
            self.isEmphasized = isEmphasized
        }
    }
}
