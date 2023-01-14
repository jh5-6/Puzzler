//
//  AddSecondView2Controller.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/11/08.
//

import UIKit
import CoreData
import BSImagePicker
import Photos
import VisionKit


class AddSecondView2Controller : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cellKeywordList = [CellTag]()
    
    var vc_category: String = ""
    var vc_type: String = ""
    var vc_date: String = ""
    var vc_title: String = ""
    var vc_score: String = ""
    var vc_department: String = ""
    var vc_memo: String = ""
    
    //label
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_score: UILabel!
    @IBOutlet weak var lbl_department: UILabel!
    @IBOutlet weak var lbl_memo: UILabel!
    
    @IBOutlet weak var lbl_type_star: UILabel!
    @IBOutlet weak var lbl_title_star: UILabel!
    @IBOutlet weak var lbl_score_star: UILabel!
    
    //
    @IBOutlet weak var text_category: defaultTextField!
    @IBOutlet weak var text_type: UITextField!
    @IBOutlet weak var text_date: UITextField!
    @IBOutlet weak var text_title: UITextField!
    @IBOutlet weak var text_score: UITextField!
    
    @IBOutlet weak var text_department: UITextField!
    @IBOutlet weak var textView_memo: DefaultTextView!
    
    @IBOutlet weak var btn_save: UIButton!
    
    @IBOutlet weak var collection_keyword: UICollectionView!
    @IBOutlet weak var collection_image: UICollectionView!
    
    let viewManager = ViewManager()
    var essentialStarLabelList = [UILabel]()
    
    //첨부사진
    let picker = UIImagePickerController()
    let multiple_picker = ImagePickerController()
    var images = [Data]()
    
    let datePickerManager = DatePickerManager()
    let startDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerManager.setup(txt_start: text_date, picker_start: startDatePicker, date: Date())
        
        //필수 입력 항목 설정
        setEssentialItemList()
        
        //set all label text by category
        setLabels(category: vc_category, type: vc_type, date: vc_date, title: vc_title, score: vc_score, department: vc_department)
        
        //textview placeholder 설정
        viewManager.setMemoPlaceholder(textView: textView_memo)
        
        
        //버튼 비활성화 및 색상 설정
        btn_save.isEnabled = false
        viewManager.setBtnColor(button: btn_save)
        
        //첨부사진 초기화
        viewManager.setImagePicker(vc: self, picker: picker, multiple_picker: multiple_picker, images: images)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedImages), name: NSNotification.Name(rawValue: "selectedImages"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImage(_:)), name: NSNotification.Name(rawValue: "addDeleteImage2"), object: nil)
        
        
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
        
        vc.addView = 2
        vc.image = sender.backgroundImage(for: .normal)!
        vc.tag = sender.tag
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func deleteImage(_ notification : NSNotification) {
        let tag = notification.object as! Int
        images.remove(at: tag)
        collection_image.reloadData()
    }
    
    
    // back button
    @IBAction func didTapButtonBack() {
        viewManager.dissmissWindow(vc: self)
    }
    
    // career record save
    @IBAction func didTapButtonSave(_ sender: UIButton) {
        
        let id = UUID().uuidString
        let keywords = viewManager.getKeywords(cellKeywordList: cellKeywordList)
        
        let date = viewManager.stringToDate(string: text_date.text!)
        
        
        viewManager.saveNewRecord(id: id, category: text_category.text!, title: text_title.text ?? "", start_date: date, end_date: date, location: text_department.text ?? "", type: text_type.text ?? "", score: text_score.text ?? "", major: "", minor: "", grades_total: "", grades_major: "", content: "", memo: textView_memo.text, keywords: keywords, images: images)
        
        viewManager.dissmissWindow(vc: self)
    }
    
    
    @IBAction func getImgPicker(_ sender: UIButton) {
        
        viewManager.getImgPicker(vc: self)
    }
    
    
    @IBAction func deleteImgAll(_ sender: Any) {
        if (images.count > 0) {
            
            let alert = UIAlertController(title: "", message: "첨부사진을 모두 삭제하시겠습니까?", preferredStyle: .actionSheet)
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
    private func setLabels(category: String, type: String, date: String, title: String, score: String, department: String) {
        
        if (vc_category == "수상경력") {
            lbl_score.isHidden = true
            text_score.isHidden = true
        }
        
        text_category.text = vc_category
        
        lbl_type.text = type
        lbl_date.text = date
        lbl_title.text = title
        lbl_score.text = score
        lbl_department.text = department
        
        viewManager.setEssentialItemStarLabel(lbl_star: essentialStarLabelList)
    }
    
    private func setEssentialItemList() {
        var essentialFieldList = [UITextField]()
        let essentialViewList = [DefaultTextView]()
        
        switch vc_category {
        case "수상경력", "자격증":
            essentialFieldList = [text_type, text_title]
            essentialStarLabelList = [lbl_type_star, lbl_title_star]
            break
        case "어학시험":
            essentialFieldList = [text_type, text_title, text_score]
            essentialStarLabelList = [lbl_type_star, lbl_title_star, lbl_score_star]
            break
        default:
            break
        }
        
        viewManager.setEssentialItemList(field: essentialFieldList, view: essentialViewList)
    }
    
    //collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == collection_keyword) {
            return AssetsString.KEYWORD.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if (collectionView == collection_keyword) {
            print("keyword")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_keyword", for: indexPath) as? CellTag else {
                return UICollectionViewCell()
            }
            
            cell.btn.setTitle(AssetsString.KEYWORD[indexPath.row], for: .normal)
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


