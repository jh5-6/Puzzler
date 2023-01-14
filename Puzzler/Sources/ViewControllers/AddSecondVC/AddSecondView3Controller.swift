//
//  AddSecondView3Controller.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/11/08.
//

import UIKit
import CoreData
import BSImagePicker
import Photos
import VisionKit

class AddSecondView3Controller : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var vc_category: String = ""
    
    //첨부사진
    let picker = UIImagePickerController()
    let multiple_picker = ImagePickerController()
    //첨부사진 스캔
    var images = [Data]()
    
    
    @IBOutlet weak var lbl_school: UILabel!
    @IBOutlet weak var lbl_school_star: UILabel!
    
    //text view
    @IBOutlet weak var text_category: defaultTextField!
    @IBOutlet weak var text_start: UITextField!
    @IBOutlet weak var text_end: UITextField!
    @IBOutlet weak var text_school: UITextField!
    @IBOutlet weak var text_location: UITextField!
    @IBOutlet weak var text_major: UITextField!
    @IBOutlet weak var text_minor: UITextField!
    @IBOutlet weak var text_gradesTotal: UITextField!
    
    @IBOutlet weak var text_gradesMajor: UITextField!
    
    @IBOutlet weak var btn_save: UIButton!
    
    @IBOutlet weak var collection_image: UICollectionView!
    
    let viewManager = ViewManager()
    var essentialStarLabelList = [UILabel]()
    
    
    let datePickerManager = DatePickerManager()
    let endDatePicker = UIDatePicker()
    let startDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //date picker 설정
        datePickerManager.setup(txt_start: text_start, txt_end: text_end, picker_start: startDatePicker, picker_end: endDatePicker, start: Date(), end: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        
        //필수 입력 항목 설정
        setEssentialItemList()
        
        setLabels(category: vc_category)
        
        
        //버튼 비활성화 및 색상 설정
        btn_save.isEnabled = false
        viewManager.setBtnColor(button: btn_save)
        
        //첨부사진 초기화
        viewManager.setImagePicker(vc: self, picker: picker, multiple_picker: multiple_picker, images: images)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedImages), name: NSNotification.Name(rawValue: "selectedImages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImage(_:)), name: NSNotification.Name(rawValue: "addDeleteImage3"), object: nil)
        
        
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBtnState(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    //키보드 숨기기
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // btn_save 활성화/비활성화 설정
    @objc func setBtnState(_ button : UIButton) {
        
        if viewManager.isFilledRequiredItems() {
            viewManager.setBtnEnabled(button: btn_save)
        } else {
            viewManager.setBtnDisabled(button: btn_save)
        }
    }
    
    @objc func getSelectedImages(_ notification: NSNotification) {
        let objects = notification.object as! [Data]
        for item in objects {
            images.append(item)
        }
        collection_image.reloadData()
    }
    
    
    @objc func showDetailImage(_ sender : UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "customAlertView") as? AlertImage else { return }
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        
        vc.addView = 3
        vc.image = sender.backgroundImage(for: .normal)!
        vc.tag = sender.tag
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func deleteImage(_ notification : NSNotification) {
        let tag = notification.object as! Int
        images.remove(at: tag)
        collection_image.reloadData()
    }
    
    // back button tap event func
    @IBAction func didTapButtonBack() {
        viewManager.dissmissWindow(vc: self)
    }
    
    // career record save
    @IBAction func didTapButtonSave(_ sender: UIButton) {
        let id = UUID().uuidString
        
        let date_start = viewManager.stringToDate(string: text_start.text!)
        var date_end = Date()
        if text_end.text == "" {
            date_end = Calendar.current.date(byAdding: .day, value: -1, to: date_start)!
        } else {
            date_end = viewManager.stringToDate(string: text_end.text!)
        }
        
        viewManager.saveNewRecord(id: id, category: text_category.text!, title: text_school.text ?? "", start_date: date_start, end_date: date_end, location: text_location.text ?? "", type: "", score: "", major: text_major.text ?? "", minor: text_minor.text ?? "", grades_total: text_gradesTotal.text ?? "", grades_major: text_gradesMajor.text ?? "", content: "", memo: "", keywords: "", images: images)
        
        viewManager.dissmissWindow(vc: self)
    }
    
    
    @IBAction func getImgPicker(_ sender: UIButton) {
        
        viewManager.getImgPicker(vc: self)
    }
    
    
    @IBAction func deleteImgAll(_ sender: Any) {
        if (images.count > 0) {
            let alert = UIAlertController(title: "", message: "첨부사진을 모두 삭제하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "삭제", style: .destructive) { (ok) in
                self.images.removeAll()
                self.collection_image.reloadData()
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: false, completion: nil)
        }
    }
    
    
    private func setLabels(category: String) {
        text_category.text = vc_category
        
        viewManager.setEssentialItemStarLabel(lbl_star: essentialStarLabelList)
    }
    
    private func setEssentialItemList() {
        let essentialFieldList : [UITextField] = [text_school]
        let essentialViewList = [DefaultTextView]()
        
        essentialStarLabelList = [lbl_school_star]
        
        viewManager.setEssentialItemList(field: essentialFieldList, view: essentialViewList)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell_image", for: indexPath) as? CellImageCollection else {
            return UICollectionViewCell()
        }
        
        cell.image.tag = indexPath.row
        cell.image.setBackgroundImage(UIImage(data: images[indexPath.row]), for: .normal)
        cell.image.addTarget(self, action: #selector(showDetailImage), for: .touchUpInside)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collection_image.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableView", for: indexPath)
            return footerView
        default:
            assert(false)
        }
        return UICollectionReusableView()
    }
}
