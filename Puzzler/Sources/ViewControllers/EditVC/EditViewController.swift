//
//  EditViewController.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/07.
//

import Foundation
import UIKit
import BSImagePicker

class EditViewController : UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var vc_record: Records = Records()
    
    // label text 내용
    var vc_category: String = ""
    var vc_title: String = ""
    var vc_date: String = ""
    var vc_dateStart: String = ""
    var vc_dateEnd: String = ""
    var vc_location: String = ""
    var vc_content: String = ""
    
    var cellKeywordList = [CellTag]()
    
    //label
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_dateStart: UILabel!
    @IBOutlet weak var lbl_dateEnd: UILabel!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var lbl_memo: UILabel!
    
    //star label
    @IBOutlet weak var lbl_title_star: UILabel!
    @IBOutlet weak var lbl_location_star: UILabel!
    @IBOutlet weak var lbl_content_star: UILabel!
    
    //input field
    @IBOutlet weak var text_category: defaultTextField!
    @IBOutlet weak var text_title: UITextField!
    @IBOutlet weak var text_start: UITextField!
    @IBOutlet weak var text_end: UITextField!
    @IBOutlet weak var text_location: UITextField!
    @IBOutlet weak var textView_content: DefaultTextView!
    @IBOutlet weak var textView_memo: DefaultTextView!
    
    @IBOutlet weak var btn_edit: UIButton!
    
    @IBOutlet weak var collection_keyword: UICollectionView!
    @IBOutlet weak var collection_image: UICollectionView!
    
    
    let viewManager = ViewManager()
    let picker = UIImagePickerController()
    let multiple_picker = ImagePickerController()
    
    var esstentialStarLabelList = [UILabel]()
    var keywordList: [String] = [String]()
    var images = [Data]()
    
    let datePickerManager = DatePickerManager()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()

    
    var view_pinch: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerManager.setup(txt_start: text_start, txt_end: text_end, picker_start: startDatePicker, picker_end: endDatePicker, isEdit: true, start: vc_record.start_date!, end: vc_record.end_date!)
     
        //필수 입력 항목 설정
        setEssentialItemList()
        
        //set all label text by category
        setLabels(title: vc_title, date: vc_date, date_start: vc_dateStart, date_end: vc_dateEnd, location: vc_location, content: vc_content)
        setEssentialItemStarLabel(lbl_star: esstentialStarLabelList)
        
        //버튼 비활성화 및 색상 설정
        viewManager.setBtnColor(button: btn_edit)
        
        
        //첨부사진 초기화 및 사진추가 
        images = vc_record.images!

        viewManager.setImagePicker(vc: self, picker: picker, multiple_picker: multiple_picker, images: images)
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedImages), name: NSNotification.Name(rawValue: "selectedImages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImage(_:)), name: NSNotification.Name(rawValue: "deleteImage"), object: nil)
        
        
        setContents(record: vc_record)
        
        //textview placeholder 설정
        viewManager.setContentPlaceholder(textView: textView_content, message: vc_record.content!)
        viewManager.setMemoPlaceholder(textView: textView_memo, message: vc_record.memo!)
        
        hideKeyboard()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBtnState(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setBtnState(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
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
    
    // btn_edit 활성화/비활성화 설정
    @objc func setBtnState(_ button : UIButton) {
        
        if (viewManager.isFilledRequiredItems()) {
            viewManager.setBtnEnabled(button: btn_edit)
        } else {
            viewManager.setBtnDisabled(button: btn_edit)
        }
    }
    
    @objc func getSelectedImages(_ notification: NSNotification) {
        let objects = notification.object as! [Data]

        for item in objects {
            images.append(item)
        }

        collection_image.reloadData()
    }
    
    @objc func deleteImage(_ notification : NSNotification) {
        let tag = notification.object as! Int

        images.remove(at: tag)
        collection_image.reloadData()
    }
    
    @objc func showDetailImage(_ sender : UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "customAlertView") as? AlertImage else { return }

        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        
        vc.editView = 1
        vc.image = sender.backgroundImage(for: .normal)!
        vc.tag = sender.tag
        present(vc, animated: true, completion: nil)

    }

    // back button tap event func
    @IBAction func didTapButtonBack() {
        viewManager.dissmissWindow(vc: self)
    }
    
    // career record save button event func
    @IBAction func didTapButtonEdit(_ sender: UIButton) {
        
        let id = vc_record.id!
        let keywords = viewManager.getKeywords(cellKeywordList: cellKeywordList)
        print("update keyword = \(keywords)")
        
        let date_start = viewManager.stringToDate(string: text_start.text!)
        var date_end = Date()
        if text_end.text == "" {
            date_end = Calendar.current.date(byAdding: .day, value: -1, to: date_start)!
        } else {
            date_end = viewManager.stringToDate(string: text_end.text!)
        }
        
        // core data update
        viewManager.updateRecord(id: id, category: text_category.text!, title: text_title.text ?? "", start_date: date_start, end_date: date_end, location: text_location.text ?? "", type: "", score: "", major: "", minor: "", grades_total: "", grades_major: "", content: textView_content.text, memo: textView_memo.text, keywords: keywords, images: images)
    
        
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
    
    
    // set all label text by category
    private func setLabels(title: String, date: String, date_start: String, date_end: String, location: String, content: String) {
        
        text_category.text = vc_category
        
        lbl_title.text = title
        lbl_date.text = date
        lbl_dateStart.text = date_start
        lbl_dateEnd.text = date_end
        lbl_location.text = location
        lbl_content.text = content
        
    }
    
    private func setContents(record: Records) {
    
        text_title.text = record.title!
        text_location.text = record.location!
        keywordList = viewManager.splitString(string: record.keywords!)
    }
    
    
    private func setEssentialItemStarLabel(lbl_star: [UILabel]) {
        viewManager.setEssentialItemStarLabel(lbl_star: esstentialStarLabelList)
    }
    
    
    private func setEssentialItemList() {
        var essentialFieldList = [UITextField]()
        var essentialViewList = [DefaultTextView]()
        
        switch vc_category {
        case "경력사항", "교육사항", "대외활동":
            essentialFieldList = [text_title, text_location]
            essentialViewList = [textView_content]
            esstentialStarLabelList = [lbl_title_star, lbl_location_star, lbl_content_star]
            break
        default:
            break
        }
        
        viewManager.setEssentialItemList(field: essentialFieldList, view: essentialViewList)
    }
    
    
    // collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collection_keyword) {
            return AssetsString.KEYWORD.count
        } else {
            print("images = \(images.count)")
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collection_keyword) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_keyword", for: indexPath) as? CellTag else {
                return UICollectionViewCell()
            }
            
            cell.btn.setTitle(AssetsString.KEYWORD[indexPath.row], for: .normal)

            for keyword in keywordList {
                if cell.btn.currentTitle! == keyword {
                    cell.isTagged = true
                    cell.backgroundColor = UIColor.init(named: "MainColor")
                    cell.btn.setTitleColor(UIColor.white, for: .normal)
                }
            }
            
            cellKeywordList.append(cell)
            
            return cell
            
        } else {
            guard  let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell_image", for: indexPath) as? CellImageCollection else {
                return UICollectionViewCell()
            }
            
            cell.image.tag = indexPath.row
            cell.image.setBackgroundImage(UIImage(data: images[indexPath.row]), for: .normal)
            cell.image.addTarget(self, action: #selector(showDetailImage), for: .touchUpInside)
            
            return cell
        }
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
