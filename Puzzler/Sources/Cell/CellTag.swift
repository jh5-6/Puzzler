//
//  KeyWordClass.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/03.
//

import Foundation
import UIKit

class CellTag: UICollectionViewCell {
    
    @IBOutlet weak var btn: UIButton!
    
    var isTagged : Bool = false
    var originalColor = UIColor(named: "MainBackground")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagging)))
        self.layer.cornerRadius = ViewManager.CORNER_RADIUS
    }
    
    @objc func tagging(_ sender: Any) {
        
        if isTagged == false {
            originalColor = self.backgroundColor
            isTagged = true
            print(isTagged)
            self.backgroundColor = UIColor(named: "MainColor")
            btn.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            isTagged = false
            print(isTagged)
            self.backgroundColor = originalColor
            btn.setTitleColor(UIColor.black, for: .normal)            
        }
    }
}
