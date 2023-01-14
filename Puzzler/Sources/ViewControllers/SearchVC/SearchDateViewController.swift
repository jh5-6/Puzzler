//
//  SearchDateViewController.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/25.
//

import Foundation
import UIKit

class SearchDateViewController : UIViewController {
    
 
    @IBOutlet weak var text_start: UITextField!
    @IBOutlet weak var text_end: UITextField!
    
    
    let startPicker = UIPickerView()
    let endPicker = UIPickerView()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var date_start: Date!
    var date_end: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date_start = Date()
        date_end = Date()
        showStartDatePicker(text_start)
        showEndDatePicker(text_end)
    }
    
    
    @IBAction func btn_cancel(_ sender: Any) {
        //현재 페이지 닫기
        ViewManager().dissmissWindow(vc: self)
    }
    
    @IBAction func btn_ok(_ sender: Any) {
        //filter 적용
    
        if(text_start.text != "" && text_end.text != "") {
            print("date filter")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchFilterDate"), object: [date_start, date_end])
        } else if (text_start.text != "") {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchFilterStartDate"), object: date_start)
        } else if (text_end.text != "") {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchFilterEndDate"), object: date_end)
        }
        
        ViewManager().dissmissWindow(vc: self)
    }

    
    func showStartDatePicker(_ sender: UITextField) {
        
        startPicker.delegate = self
        startPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(onStartPickerDone))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  
        toolBar.setItems([btnSpace, btnDone], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        text_start.inputAccessoryView = toolBar
        text_start.inputView = startPicker
        
    }
    
    @objc func onStartPickerDone(_ sender : AnyObject) {

        text_start.text = ""
        text_start.resignFirstResponder()
    }
    
    
    @objc func startDatePickerValueChanged(_ sender: UIDatePicker) {
        
        date_start = sender.date
        endDatePicker.minimumDate = date_start
    }
    
    @objc func onStartDatePickerDone(_ sender : AnyObject) {
        
        let stringDate = ViewManager().dateToString(date: date_start)
        
        text_start.text = stringDate
        text_start.resignFirstResponder()
    }
    
    @objc func onStartDatePickerCancel(_ sender : AnyObject) {
        
        text_start.resignFirstResponder()
    }
    
    
    func showEndDatePicker(_ sender: UITextField) {
        
        endPicker.delegate = self
        endPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(onEndPickerDone))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  
        toolBar.setItems([btnSpace, btnDone], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        text_end.inputAccessoryView = toolBar
        text_end.inputView = endPicker
    }
    
    @objc func onEndPickerDone(_ sender : AnyObject) {

        text_end.text = ""
        text_end.resignFirstResponder()
    }
    
    
    @objc func endDatePickerValueChanged(_ sender: UIDatePicker) {
        
        date_end  = sender.date
        startDatePicker.maximumDate = date_end
    }
    
    
    @objc func onEndDatePickerDone(_ sender : AnyObject) {
        
        let stringDate = ViewManager().dateToString(date: date_end)
        text_end.text = stringDate
        text_end.resignFirstResponder()
    }
    
    
    @objc func onEndDatePickerCancel(_ sender : AnyObject) {
        
        text_end.resignFirstResponder()
    }
}

extension SearchDateViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return ViewManager.PICKER_ITEM.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(ViewManager.PICKER_ITEM[row])"
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (row == 1) {
            if(pickerView == startPicker) {
                startDatePicker.datePickerMode = UIDatePicker.Mode.date
                startDatePicker.preferredDatePickerStyle = .wheels
                startDatePicker.locale = NSLocale(localeIdentifier: "ko_kr") as Locale
                
                startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
                
                let toolBar = UIToolbar()
                toolBar.sizeToFit()
                
                let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(onStartDatePickerDone))
                let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let btnCancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onStartDatePickerCancel))
                
                toolBar.setItems([btnCancel, btnSpace, btnDone], animated: false)
                toolBar.isUserInteractionEnabled = true
                
                
                text_start.inputAccessoryView = toolBar
                text_start.inputView = startDatePicker
                text_start.reloadInputViews()
                
            } else  {
            endDatePicker.datePickerMode = UIDatePicker.Mode.date
            endDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.locale = NSLocale(localeIdentifier: "ko_kr") as Locale
            
            endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
            
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            
            let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(onEndDatePickerDone))
            let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let btnCancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onEndDatePickerCancel))
            
            toolBar.setItems([btnCancel, btnSpace, btnDone], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            
            text_end.inputAccessoryView = toolBar
            text_end.inputView = endDatePicker
            text_end.reloadInputViews()
            }
        }
        
    }
    
}
