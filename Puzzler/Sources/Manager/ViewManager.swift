//
//  AddViewManager.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/11/17.
//

import Foundation
import UIKit
import VisionKit
import BSImagePicker
import Photos

class ViewManager : UIViewController, VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate {
    
    private var vc: UIViewController!
    
    static let CORNER_RADIUS : CGFloat = 7
    static let SEPARATOR : String = "-"
    
    //date picker item
    static let PICKER_ITEM = ["선택안함", "날짜 선택"]
    
    //add view, edit view label
    //view1: career, seminar, extra
    //view2: awards, language, certificate
    static let view1_label = [["직급 및 근무 부서", "근무기간", "시작일", "종료일", "근무지", "업무내용"], ["교육과정명", "교육기간", "시작일", "종료일", "교육시행기관", "교육내용 및 사유"], ["활동명", "활동기간", "시작일", "종료일", "기관/장소", "활동내용"]]
    static let view2_label = [["대회명", "수여일자", "수상명", "수상명", "수여기관"], ["외국어명", "취득일자", "시험명", "점수", "평가기관"], ["자격증명", "취득일자", "자격번호", "자격등급", "발행기관"]]
    
    
    //필수입력 항목
    private var essentialFieldList = [UITextField]()
    private var essentialViewList = [UITextView]()
    
    
    //첨부사진 관련 변수
    private var picker = UIImagePickerController()
    private var multiple_picker = ImagePickerController()
    private var images = [Data]()
    var selectedAssets = [PHAsset]()
    
    
    //첨부 사진
    func setImagePicker(vc: UIViewController, picker: UIImagePickerController, multiple_picker: ImagePickerController, images: [Data]){
        
        self.vc = vc
        self.picker = picker
        self.multiple_picker = multiple_picker
        self.images = images
    }
    
    func getImgPicker(vc: UIViewController) {
        multiple_picker.delegate = self
        picker.delegate = self
        
        let alert = UIAlertController(title: "Select one.", message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "앨범에서 사진 선택", style:.default) { (action) in self.openLibrary()}
        let camera = UIAlertAction(title: "사진 촬영", style: .default) { (action) in self.openCamera()}
        let scan = UIAlertAction(title: "문서 스캔", style: .default) { (action) in self.openScanner()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(scan)
        alert.addAction(cancel)
        
        presentAlert(vc: vc as UIViewController, alert: alert)
    }
    
    
    
    //datePicker & tool bar 
    func setDatePicker(picker: UIDatePicker) {
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = NSLocale(localeIdentifier: "ko_kr") as Locale
    }
    
    
    // 저장, 수정 버튼 관련 함수
    // 필수 항목 사항 설정
    func setEssentialItemList(field: [UITextField], view: [DefaultTextView]) {
        essentialFieldList = field
        essentialViewList = view
    }
    
    // 해당 항목 입력/미입력 확인
    func isFilled(_ text: String) -> Bool {
        guard !(text == AssetsString.PLACEHOLDER_CONTENT || text == AssetsString.PLACEHOLDER_MEMO || text == "") else {
            return false
        }
        return true
    }
    
    // 필수 항목 입력 상태 확인
    func isFilledRequiredItems() -> Bool {
        // 필수 항목 확인1 - textField
        if !essentialFieldList.isEmpty {
            for field in essentialFieldList {
                if !isFilled(field.text ?? "") {
                    return false
                }
            }
        }
        
        if !essentialViewList.isEmpty {
            // 필수 항목 확인2 -textView
            for view in essentialViewList {
                if !isFilled(view.text ?? "") {
                    return false
                }
            }
        }
        return true
    }
    
    func isEdited() -> Bool {
        if (isFilledRequiredItems()){
            
            return true
        }
        
        return false
    }
    
    func setEssentialItemStarLabel(lbl_star: [UILabel]) {
        for lbl in lbl_star {
            lbl.text = "*"
            lbl.textColor = UIColor(named: "MainColor")
        }
    }
    
    // ipad alert view
    func presentAlert(vc: UIViewController, alert: UIAlertController) {

        if UIDevice.current.userInterfaceIdiom == .pad {
            //디바이스 타입이 iPad일때
            if let popoverController = alert.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 저장해줍니다.
                popoverController.sourceView = vc.view
                popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                vc.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            vc.present(alert, animated: true, completion: nil)
            
        }
    }
    
    //textView placeholder 설정 :
    //content textview의 placeholder 설정하는 경우
    public func setContentPlaceholder(textView: DefaultTextView, message: String = "") {
        setPlaceholder(textView: textView, placeholder_message: AssetsString.PLACEHOLDER_CONTENT, message: message)
    }
    
    //memo textview의 placeholder 설정하는 경우
    public func setMemoPlaceholder(textView: DefaultTextView, message: String = "") {
        setPlaceholder(textView: textView, placeholder_message: AssetsString.PLACEHOLDER_MEMO, message: message)
    }
    
    private func setPlaceholder(textView: DefaultTextView, placeholder_message: String, message: String) {
        textView.delegate = textView
        
        if (message == "") {
            textView.setPlaceholder(init_message: placeholder_message, current_message: placeholder_message)
        } else {
            textView.setPlaceholder(init_message: placeholder_message, current_message: message)
        }
    }
    
    // 버튼 색상 설정
    func setBtnColor(button: UIButton) {
        button.setTitleColor(UIColor.init(named: "MainColor"), for: .normal)
        button.setTitleColor(UIColor.init(named: "LightGrey"), for: .disabled)
    }
    
    // 버튼 활성화
    func setBtnEnabled(button: UIButton) {
        button.isEnabled = true
    }
    
    // 버튼 비활성화
    func setBtnDisabled(button: UIButton) {
        button.isEnabled = false
    }
    
    // 창 닫기 
    func dissmissWindow(vc: UIViewController) -> Void {
        vc.dismiss(animated: true, completion: nil)
    }
    
    //Date type -> String으로 변환
    func dateToString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
        
    }
    
    func stringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        let date = dateFormatter.date(from: string)!
        
        return date
    }
    
    func splitString(string: String) -> [String] {
        return string.components(separatedBy: ViewManager.SEPARATOR)
    }
    
    func getKeywords(cellKeywordList: [CellTag]) -> String{
        var keywords = [String]()
        
        for keyword in cellKeywordList {
            if keyword.isTagged {
                keywords.append(keyword.btn.currentTitle!)
            }
        }
        return keywords.joined(separator: ViewManager.SEPARATOR)
    }
    
    // save data
    // ** fileprivate 찾아보기 
    func saveNewRecord(id: String, category: String, title: String, start_date: Date, end_date: Date, location: String, type: String, score: String, major: String, minor: String, grades_total: String, grades_major: String, content: String, memo: String, keywords: String, images: [Data]) {
        
        print("save images = \(images.count)")
        CoreDataManager.shared.saveRecords(id: id, category: category, title: title, start_date: start_date, end_date: end_date, location: location, type: type, score: score, major: major, minor: minor, grades_total: grades_total, grades_major: grades_major, content: content, memo: memo, keywords: keywords, images: images)
    }
    
    func updateRecord(id: String, category: String, title: String, start_date: Date, end_date: Date, location: String, type: String, score: String, major: String, minor: String, grades_total: String, grades_major: String, content: String, memo: String, keywords: String, images: [Data]) {
        
        CoreDataManager.shared.updateRecords(id: id, category: category, title: title, start_date: start_date, end_date: end_date, location: location, type: type, score: score, major: major, minor: minor, grades_total: grades_total, grades_major: grades_major, content: content, memo: memo, keywords: keywords, images: images)
        
    }
    
    func deleteRecord(id: String){
        CoreDataManager.shared.deleteRecords(id: id)
    }
    
    
    func convertCategoryToEn(category: String) -> String {
        
        for i in 0...AssetsString.CATEGORY.count {
            if category == AssetsString.CATEGORY[i] {
                return AssetsString.CATEGORY_EN[i]
            }
        }
        return ""
    }
    
    func convertCategoryToKor(category: String) -> String {
        
        for i in 0...AssetsString.CATEGORY.count {
            if category == AssetsString.CATEGORY_EN[i] {
                return AssetsString.CATEGORY[i]
            }
        }
        return ""
    }
}

// 첨부사진 - 앨범에서 사진 가져오기, 사진 촬영하기, 문서 스캔하기
extension ViewManager : UIImagePickerControllerDelegate , UINavigationBarDelegate {
    func convertAssetToData(assets: [PHAsset]) -> [Data] {
        var images = [Data]()
        
        if assets.count != 0 {
            for asset in assets {
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option){ (result, info) in
                    thumbnail = result!
                    
                }
                let data = thumbnail.jpegData(compressionQuality: 1.0)
                images.append(data!)
            }
        }
        return images
    }
    
    
    func openLibrary() {
        multiple_picker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        for asset in selectedAssets {
            multiple_picker.deselect(asset: asset)
        }
        
        vc.presentImagePicker(multiple_picker, animated: true, select: { (assets) in }, deselect: { (assets) in }, cancel: { (assets) in }, finish: { (assets) in
            
            self.selectedAssets = assets
            let selectedImages = self.convertAssetToData(assets: assets)
            
            self.vc.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedImages"), object: selectedImages)
        })
    }
    
    func openCamera() {
        picker.sourceType = .camera
        vc.present(picker, animated: false, completion: nil)
    }
    
    func openScanner() {
        visionKit()
    }
    
    private func visionKit() {
        let scan = VNDocumentCameraViewController()
        scan.delegate = self
        vc.present(scan, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var images = [Data]()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(image.jpegData(compressionQuality: 1.0)!)
            
            vc.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedImages"), object: images)
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        var documents = [Data]()
        
        for idx in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: idx).jpegData(compressionQuality: 1.0)
            documents.append(image!)
        }
        
        controller.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedImages"), object: documents)
    }
}
