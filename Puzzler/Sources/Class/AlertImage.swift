//
//  AlertImage.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2022/01/16.
//

import Foundation
import UIKit

class AlertImage : UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    //edit view1,edit view 2,edit view3 구분 flag 변수
    var editView: Int = 0
    var addView: Int = 0
    
    var image: UIImage = UIImage()
    var tag: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
        
        self.imageView.image = image
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        
        if pinch.state == .began || pinch.state == .changed {
            guard let view = pinch.view else { return }
            
            // pinch gesture의 위치를 잡고 그 가운데를 확대/축소의 중심으로 설정
            let pinchCenter = CGPoint(x: pinch.location(in: view).x - view.bounds.midX,
                                      y: pinch.location(in: view).y - view.bounds.midY)
            
            // 이미지 뷰의 중점이 아닌, pinch gesture를 중점으로 + 이미지 확대/축소
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: pinch.scale, y: pinch.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            
            var newScale = currentScale * pinch.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                imageView.transform = transform
                pinch.scale = 1
            } else {
                imageView.transform = transform
            }
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        if (editView != 0) {
            switch editView {
            case 1:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteImage"), object: tag)
                
            case 2:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteImage2"), object: tag)
                
            case 3:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteImage3"), object: tag)
            default:
                return
            }
        } else {
            switch addView {
            case 1:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addDeleteImage"), object: tag)
                
            case 2:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addDeleteImage2"), object: tag)
                
            case 3:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addDeleteImage3"), object: tag)
            default:
                return
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
