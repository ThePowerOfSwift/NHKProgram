import UIKit

import RxSwift
import RxCocoa

class ProgramTableViewCell: UITableViewCell {
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    
    private let bag = DisposeBag()
    var subscriptionBag = DisposeBag()
    
    let data = Data(startTimeText: "00:00", endTimeText: "00:00", programTitle: "", programDescription: "")
    
    override func awakeFromNib() {
        [startTimeLabel, endTimeLabel]
            .forEach { $0.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: UIFontWeightRegular) }
        
        initializeRx()
    }
    
    private func initializeRx() {
        data.startTimeText.asDriver().drive(startTimeLabel.rx.text).disposed(by: bag)
        data.endTimeText.asDriver().drive(endTimeLabel.rx.text).disposed(by: bag)
        data.programTitle.asDriver().drive(programTitleLabel.rx.text).disposed(by: bag)
        data.programDescription.asDriver().drive(programDescriptionLabel.rx.text).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptionBag = DisposeBag()
    }
}

extension ProgramTableViewCell {
    struct Data {
        var startTimeText: Variable<String>
        var endTimeText: Variable<String>
        var programTitle: Variable<String>
        var programDescription: Variable<String>
        
        init(startTimeText: String, endTimeText: String, programTitle: String, programDescription: String) {
            self.startTimeText = Variable(startTimeText)
            self.endTimeText = Variable(endTimeText)
            self.programTitle = Variable(programTitle)
            self.programDescription = Variable(programDescription)
        }
    }
}
