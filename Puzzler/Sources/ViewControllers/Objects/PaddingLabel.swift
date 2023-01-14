////
////  PaddingLabel.swift
////  Buzzler
////
////  Created by Jeeyeun Park on 2021/11/17.
////
//
//import Foundation
//import UIKit
//
//class PaddingLabel : UILabel {
//    
//    private var padding = UIEdgeInsets(top: 17.0, left: 9.0, bottom: 17.0, right: 9.0)
//    
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: padding))
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        var contentSize = super.intrinsicContentSize
//        contentSize.height += (padding.top + padding.bottom)
//        contentSize.width += (padding.left + padding.right)
//        
//        return contentSize
//    }
//}
