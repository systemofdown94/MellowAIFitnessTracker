import UIKit

extension UIDevice {
    static var isSE: Bool {
        UIScreen.main.bounds.height < 700
    }
}
