////
////  TouchEventButton.swift
////  Buzzler
////
////  Created by Jeeyeun Park on 2021/12/05.
////
//
//import Foundation
//import UIKit
//
//class TouchEventButton : UIButton{
//    
//    var originalColor : UIColor?
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//        originalColor = self.backgroundColor
//        self.backgroundColor = UIColor(named: "MainColor")
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        
//        self.backgroundColor = originalColor
//    }
//}
