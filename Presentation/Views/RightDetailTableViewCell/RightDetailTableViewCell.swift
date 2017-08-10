import UIKit

import RxSwift
import RxCocoa

class RightDetailTableViewCell: UITableViewCell {
    private let bag = DisposeBag()
    var subscriptionBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    let data = Variable(Data(title: "", rightText: ""))
    
    override func awakeFromNib() {
        initializeRx()
    }
    
    private func initializeRx() {
        guard
            let titleLabel = titleLabel,
            let rightLabel = rightLabel
        else { fatalError() }
        
        let d = data.asDriver()
        
        d.map { $0.title }.drive(titleLabel.rx.text).disposed(by: bag)
        d.map { $0.rightText }.drive(rightLabel.rx.text).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptionBag = DisposeBag()
    }
}

extension RightDetailTableViewCell {
    struct Data {
        var title: String
        var rightText: String
        
        init(title: String, rightText: String) {
            self.title = title
            self.rightText = rightText
        }
    }
}
