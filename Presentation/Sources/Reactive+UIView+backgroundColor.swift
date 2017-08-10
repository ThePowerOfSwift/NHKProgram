import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    var backgroundColor: UIBindingObserver<Base, UIColor> {
        return UIBindingObserver(UIElement: self.base) { label, backgroundColor in
            label.backgroundColor = backgroundColor
        }
    }
}
