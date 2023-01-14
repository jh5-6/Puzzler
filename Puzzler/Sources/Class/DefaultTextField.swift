//
//  DefaultTextField.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2022/01/12.
//

import Foundation
import UIKit

class defaultTextField: UITextField {
    
    struct Constants{
        static let sidePadding:CGFloat = 11
        static let topPadding:CGFloat = 9
    }
    
    func setup() {
        
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.cornerRadius = ViewManager.CORNER_RADIUS
        self.backgroundColor =  UIColor.init(named: "MainBackground")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.height - Constants.topPadding * 2
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
