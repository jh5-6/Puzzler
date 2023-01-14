//
//  AddViewController.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2021/10/28.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let viewManager = ViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssetsString.CATEGORY.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell_category", for: indexPath) as? AddTableCell else {
            return UITableViewCell()
        }
        
        cell.btn_title.tag = indexPath.row
        cell.btn_image.tag = indexPath.row
        
        cell.btn_title.setTitle(AssetsString.CATEGORY[indexPath.row], for: .normal)
        cell.btn_image.setImage(UIImage(named: AssetsString.CATEGORY_EN[indexPath.row]), for: .normal)
        cell.view.layer.cornerRadius = ViewManager.CORNER_RADIUS
        
        cell.btn_image.addTarget(self, action: #selector(showDetailView_btn(_:)), for: .touchUpInside)
        cell.btn_title.addTarget(self, action: #selector(showDetailView_title(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func showDetailView_btn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowAdd" + AssetsString.CATEGORY_EN[sender.tag] + "VC", sender: nil)
    }
    
    @objc func showDetailView_title(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowAdd" + viewManager.convertCategoryToEn(category: sender.currentTitle!) + "VC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowAddCareerVC":
            let vc = segue.destination as! AddSecondViewController
            setAddViewLabel(vc: vc, category: "경력사항")
            
        case "ShowAddSeminarVC":
            let vc = segue.destination as! AddSecondViewController
            setAddViewLabel(vc: vc, category: "교육사항")
            
        case "ShowAddExtraVC":
            let vc = segue.destination as! AddSecondViewController
            setAddViewLabel(vc: vc, category: "대외활동")
            
        case "ShowAddAwardsVC":
            let vc = segue.destination as! AddSecondView2Controller
            setAddViewLabel(vc: vc, category: "수상경력")
            
        case "ShowAddLanguageVC":
            let vc = segue.destination as! AddSecondView2Controller
            setAddViewLabel(vc: vc, category: "어학시험")
            
        case "ShowAddCertificateVC":
            let vc = segue.destination as! AddSecondView2Controller
            setAddViewLabel(vc: vc, category: "자격증")
            
        case "ShowAddEduVC":
            let vc = segue.destination as! AddSecondView3Controller
            setAddViewLabel(vc: vc, category: "학력사항")
            
        default:
            break
        }
    }
    
    
    func setAddViewLabel(vc: AddSecondViewController, category: String) {
        setNextViewLabel(vc: vc, category: category)
    }
    func setAddViewLabel(vc: AddSecondView2Controller, category: String) {
        setNextViewLabel(vc: vc, category: category)
    }
    func setAddViewLabel(vc: AddSecondView3Controller, category: String) {
        setNextViewLabel(vc: vc, category: category)
    }
    
    // career, seminar, extra view
    func setNextViewLabel(vc: AddSecondViewController, category: String) {
        
        var idx: Int
        vc.vc_category = category
        
        switch category {
        case AssetsString.CATEGORY_CAREER :
            idx = 0
        case AssetsString.CATEGORY_SEMINAR :
            idx = 1
        case AssetsString.CATEGORY_EXTRA :
            idx = 2
        default:
            return
        }
        
        vc.vc_title = ViewManager.view1_label[idx][0]
        vc.vc_date = ViewManager.view1_label[idx][1]
        vc.vc_dateStart = ViewManager.view1_label[idx][2]
        vc.vc_dateEnd = ViewManager.view1_label[idx][3]
        vc.vc_location = ViewManager.view1_label[idx][4]
        vc.vc_content = ViewManager.view1_label[idx][5]
    }
    
    
    // awards, language, certificate view
    func setNextViewLabel(vc: AddSecondView2Controller, category: String) {
        
        var idx: Int
        vc.vc_category = category
        
        switch category {
        case AssetsString.CATEGORY_AWARDS :
            idx = 0
        case AssetsString.CATEGORY_LANG :
            idx = 1
        case AssetsString.CATEGORY_CERTIFICATE :
            idx = 2
        default:
            return
        }
        
        vc.vc_type = ViewManager.view2_label[idx][0]
        vc.vc_date = ViewManager.view2_label[idx][1]
        vc.vc_title = ViewManager.view2_label[idx][2]
        vc.vc_score = ViewManager.view2_label[idx][3]
        vc.vc_department = ViewManager.view2_label[idx][4]
        
    }
    
    // edu view
    func setNextViewLabel(vc: AddSecondView3Controller, category: String) {
        
        vc.vc_category = category
    }
}
