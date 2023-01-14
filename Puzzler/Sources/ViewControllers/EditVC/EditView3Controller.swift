//
//  EditView3Controller.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/07.
//

import Foundation
import UIKit
import BSImagePicker

class EditView3Controller : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
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
    
    @IBOutlet weak var btn_edit: UIButton!
    
    @IBOutlet weak var collection_image: UICollectionView!
    
    
    let viewManager = ViewManager()
    //첨부사진
    let picker = UIImagePickerController()
    let multiple_picker = ImagePickerController()
    
    var vc_record: Records = Records()
    var vc_category: String = ""
    
    var essentialStarLabelList = [UILabel]()
    //첨부사진 스캔
    var images = [Data]()
    
    
    let datePickerManager = DatePickerManager()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerManager.setup(txt_start: text_start, txt_end: text_end, picker_start: startDatePicker, picker_end: endDatePicker, isEdit: true, start: vc_record.start_date!, end: vc_record.end_date!)
        
        //필수 입력 항목 설정
        setEssentialItemList()
        
        setLabels(category: vc_category)
        
        //첨부사진 초기화
        images = vc_record.images!
        viewManager.setImagePicker(vc: self, picker: picker, multiple_picker: multiple_picker, images: images)
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedImages), name: NSNotification.Name(rawValue: "selectedImages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImage(_:)), name: NSNotification.Name(rawValue: "deleteImage3"), object: nil)
        
        setContents(record: vc_record)
        
        //버튼 비활성화 및 색상 설정
        viewManager.setBtnColor(button: btn_edit)
        
        hideKeyboard()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBtnState(_:)), name: UITextField.textDidChangeNotification, object: nil)
     
        hideKeyboard()
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
            viewManager.setBtnEnabled(button: btn_edit)
        } else {
            viewManager.setBtnDisabled(button: btn_edit)
        }
    }
    
    // 이미지 추가
    @objc func getSelectedImages(_ notification: NSNotification) {
        let objects = notification.object as! [Data]
        for item in objects {
            images.append(item)
        }
        collection_image.reloadData()
    }
    
    // 이미지 삭제
    @objc func deleteImage(_ notification : NSNotification) {
        let tag = notification.object as! Int

        images.remove(at: tag)
        collection_image.reloadData()
    }
    
    // 이미지 확대
    @objc func showDetailImage(_ sender : UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "customAlertView") as? AlertImage else { return }

        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        
        vc.editView = 3
        vc.image = sender.backgroundImage(for: .normal)!
        vc.tag = sender.tag
        present(vc, animated: true, completion: nil)

    }
 
    // back button tap event func
    @IBAction func didTapButtonBack() {
        viewManager.dissmissWindow(vc: self)
    }
    
    // career record save
    @IBAction func didTapButtonEdit(_ sender: UIButton) {
        
        let id = vc_record.id!
        
        let date_start = viewManager.stringToDate(string: text_start.text!)
        var date_end = Date()
        if text_end.text == "" {
            date_end = Calendar.current.date(byAdding: .day, value: -1, to: date_start)!
        } else {
            date_end = viewManager.stringToDate(string: text_end.text!)
        }
        
        // core data update
        viewManager.updateRecord(id: id, category: text_category.text!, title: text_school.text ?? "", start_date: date_start, end_date: date_end, location: text_location.text ?? "", type: "", score: "", major: text_major.text ?? "", minor: text_minor.text ?? "", grades_total: text_gradesTotal.text ?? "", grades_major: text_gradesMajor.text ?? "", content: "", memo: "", keywords: "", images: images)
        
        viewManager.dissmissWindow(vc: self)
    }
    
    @IBAction func didTapButtonDelete(_ sender: Any) {
        let id = vc_record.id!
        
        let alert = UIAlertController(title: "기록을 삭제하시겠습니까?", message: "한번 삭제한 기록은 복구할 수 없습니다", preferredStyle: .actionSheet)
    
        let ok = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.viewManager.deleteRecord(id: id)
            self.viewManager.dissmissWindow(vc: self)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        viewManager.presentAlert(vc: self as UIViewController, alert: alert)
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
    
    private func setContents(record: Records) {
        
        text_school.text = record.title
        text_location.text = record.location
        text_major.text = record.major
        text_minor.text = record.minor
        text_gradesTotal.text = record.grades_total
        text_gradesMajor.text = record.grades_major
    }
    
    private func setEssentialItemList() {
        let essentialFieldList : [UITextField] = [text_school]
        let essentialViewList = [DefaultTextView]()
        
        essentialStarLabelList = [lbl_school_star]
        viewManager.setEssentialItemList(field: essentialFieldList, view: essentialViewList)
    }
    
    // collection
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
