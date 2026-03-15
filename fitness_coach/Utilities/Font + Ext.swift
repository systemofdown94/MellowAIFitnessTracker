import SwiftUI

extension Font {
    enum InterFontWeight: String {
        case medium = "Inter-Medium"
        case semibold = "Inter-SemiBold"
        case bold = "Inter-Bold"
        case regular = "Inter-Regular"
    }
    
    static func inter(_ weight: InterFontWeight, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }
}

