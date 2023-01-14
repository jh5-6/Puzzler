//
//  LineSpacingLabel.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2022/01/18.
//

import Foundation
import UIKit

class LineSapcingLabel : UILabel {
    
    struct Constants{
        static let sidePadding:CGFloat = 0
        static let topPadding:CGFloat = 2
        static let lineSpace:CGFloat = 3
    }

    func setLineSpace() {
        let attrString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constants.lineSpace
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        self.attributedText = attrString
    }

    func getPadding() -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.topPadding, left: Constants.sidePadding, bottom: Constants.topPadding, right: Constants.sidePadding)
    }
    
    func setup() {
        setLineSpace()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: getPadding()))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += getPadding().top + getPadding().bottom
        contentSize.width += getPadding().left + getPadding().right
        
        return contentSize
    }
}
