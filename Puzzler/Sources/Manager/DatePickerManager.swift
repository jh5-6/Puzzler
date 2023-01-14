//
//  DatePickerManager.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/25.
//

import Foundation
import UIKit

class DatePickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var text_start = UITextField()
    private var text_end = UITextField()
    
    private var startDatePicker = UIDatePicker()
    private var endDatePicker = UIDatePicker()
    
    private var date_start = Date()
    private var date_end = Date()
    
    func setup(txt_start: UITextField, txt_end: UITextField, picker_start: UIDatePicker, picker_end: UIDatePicker, isEdit: Bool = false, start: Date, end: Date){
        self.text_start = txt_start
        self.text_end = txt_end
        self.startDatePicker = picker_start
        self.endDatePicker = picker_end
        
        setDefaultDate(start: start, end: end)
        setBoundaryDate()
        
        showStartDatePicker(text_start)
        showEndDatePicker(text_end)
    }
    
    func setup(txt_start: UITextField, picker_start: UIDatePicker, date: Date, isEdit: Bool = false){
        self.text_start = txt_start
        self.startDatePicker = picker_start
        
        setDefaultDate(date: date)
        
        showStartDatePicker(text_start)
    }
    
    func setDefaultDate(start: Date, end: Date) {
        self.date_start = start
        self.date_end = end
        
        text_start.text = ViewManager().dateToString(date: date_start)
        if (date_start > date_end)  {
            text_end.text = ""
        } else {
            text_end.text = ViewManager().dateToString(date: date_end)
        }
    }
    
    func setDefaultDate(date: Date) {
        self.date_start = date
        text_start.text = ViewManager().dateToString(date: date_start)
    }
    
    func setBoundaryDate() {
        startDatePicker.maximumDate = date_end
        endDatePicker.minimumDate = date_start
    }
    
    func showStartDatePicker(_ sender: UITextField) {
        
        startDatePicker.datePickerMode = UIDatePicker.Mode.date
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.locale = NSLocale(localeIdentifier: "ko_kr") as Locale
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(onStartDatePickerDone(_:)))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onStartDatePickerCancel))
        
        toolBar.setItems([btnCancel, btnSpace, btnDone], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        text_start.inputAccessoryView = toolBar
        text_start.inputView = startDatePicker
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
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(onDatePickerDone(_:)))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([btnSpace, btnDone], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        text_end.inputAccessoryView = toolBar
        text_end.inputView = pickerView
    }
    
    @objc func onDatePickerDone(_ sender : AnyObject) {
        
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
