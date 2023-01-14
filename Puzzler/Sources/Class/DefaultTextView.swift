//
//  PlaceholderTextView.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/11/18.
//

import Foundation
import UIKit

class DefaultTextView : UITextView {
    
    private var message : String = ""
    
    struct Constants{
        static let sidePadding:CGFloat = 7
        static let topPadding:CGFloat = 9
    }
    
    func setup() {
        setPadding()
        setLineSpace()
        
        self.layer.cornerRadius = ViewManager.CORNER_RADIUS
    }
    
    func setPadding() {
        self.textContainerInset = UIEdgeInsets(top: Constants.topPadding, left: Constants.sidePadding, bottom: Constants.topPadding, right: Constants.sidePadding)
    }
    
    func setLineSpace() {
        
        let attrString = NSMutableAttributedString(string: self.text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        self.attributedText = attrString
    }
    
    func setPlaceholder(init_message: String, current_message: String) {
        message = init_message
        self.text = current_message
        
        if !(current_message == "" || current_message == init_message) {
            self.textColor = UIColor.black
        }
    }
    
    func setTextView() {
        
        if self.text == message {
            self.text = nil
            self.textColor = UIColor.black
        } else if self.text.isEmpty {
            self.text = message
            self.textColor = UIColor.lightGray
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

extension DefaultTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextView()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setTextView()
    }
}
