//
//  HomeViewController.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2021/10/31.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var lbl_message: UILabel!
    
    let message: String = "나의 커리어를 기록하세요"
    
    var data_record: [Records] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAllRecords()
        tableView.reloadData()
    }
    
    // print all career records
    func getAllRecords() {
        let records: [Records] = CoreDataManager.shared.getAllRecords()
        self.data_record = records
    }
    
    func showEditView (vc: UIViewController, category: String, record: Records) {
   
        switch category {
        case AssetsString.CATEGORY_CAREER, AssetsString.CATEGORY_SEMINAR, AssetsString.CATEGORY_EXTRA:
            presentVC(vc: vc, category: category, identifier: "editView", record: record)
            
        case AssetsString.CATEGORY_AWARDS, AssetsString.CATEGORY_LANG, AssetsString.CATEGORY_CERTIFICATE:
            presentVC(vc: vc, category: category, identifier: "editView2", record: record)
            
        case AssetsString.CATEGORY_EDU:
            presentVC(vc: vc, category: category, identifier: "editView3", record: record)
            
        default:
            break
        }
    }
    
    func presentVC(vc: UIViewController, category: String, identifier: String, record: Records) {
        print(identifier)
        
        let vc_next = vc.storyboard?.instantiateViewController(identifier: identifier)
        vc_next?.modalTransitionStyle = .coverVertical
        vc_next?.modalPresentationStyle = .fullScreen
        
        setNextVCLabel(category: category, vc: vc_next!, record: record)
        self.present(vc_next!, animated: true, completion: nil)
    }
    
    
    func setNextVCLabel(category: String, vc: UIViewController, record: Records){
        switch category {
        case AssetsString.CATEGORY_CAREER, AssetsString.CATEGORY_SEMINAR, AssetsString.CATEGORY_EXTRA:
            setViewLabel(vc: vc as! EditViewController, category: category, record: record)
               
        case AssetsString.CATEGORY_AWARDS, AssetsString.CATEGORY_LANG, AssetsString.CATEGORY_CERTIFICATE:
            setViewLabel(vc: vc as! EditView2Controller, category: category, record: record)

        case AssetsString.CATEGORY_EDU:
            setViewLabel(vc: vc as! EditView3Controller, category: category, record: record)
            
            
        default:
            break
        }
    }
    

    func setViewLabel(vc: EditViewController, category: String, record: Records) {
    
        setNextViewLabel(vc: vc, category: category)
        vc.vc_record =  record
    }

    func setViewLabel(vc: EditView2Controller, category: String, record: Records) {

        setNextViewLabel(vc: vc, category: category)
        vc.vc_record =  record
    }

    
    func setViewLabel(vc: EditView3Controller, category: String, record: Records) {
        
        setNextViewLabel(vc: vc, category: "학력사항")
        vc.vc_record =  record
    }
    
    
    // career, seminar, extra view
    func setNextViewLabel(vc: EditViewController, category: String) {
        
        var idx: Int
        vc.vc_category = category
        
        switch category {
        case AssetsString.CATEGORY_CAREER:
            idx = 0
        case AssetsString.CATEGORY_SEMINAR:
            idx = 1
        case AssetsString.CATEGORY_EXTRA:
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
    func setNextViewLabel(vc: EditView2Controller, category: String) {
        var idx: Int
        vc.vc_category = category
        
        switch category {
        case AssetsString.CATEGORY_AWARDS:
            idx = 0
        case AssetsString.CATEGORY_LANG:
            idx = 1
        case AssetsString.CATEGORY_CERTIFICATE:
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
    func setNextViewLabel(vc: EditView3Controller, category: String) {
        vc.vc_category = category
    }
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (data_record.count > 0) {
            lbl_message.text = ""
        } else {
            lbl_message.text = message
        }
        
        return data_record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch data_record[indexPath.row].category {
        // 경력사항, 교육사항, 대외활동
        case AssetsString.CATEGORY_CAREER, AssetsString.CATEGORY_SEMINAR, AssetsString.CATEGORY_EXTRA:
            if (data_record[indexPath.row].keywords != "") {
                
                let cell: HomeTableCell = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellIndentifier, for: indexPath) as? HomeTableCell)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                cell.lbl_title.text = "\(data_record[indexPath.row].location!)"
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].title!)"
                cell.lbl_content.text = data_record[indexPath.row].content
                
                cell.keywords = ViewManager().splitString(string: data_record[indexPath.row].keywords!)
                
                cell.collection_keyword.delegate = cell
                cell.collection_keyword.dataSource = cell
                
                cell.collection_keyword.reloadData()
                
                if (data_record[indexPath.row].start_date! > data_record[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: data_record[indexPath.row].end_date!))"
                }
                
                return cell
                
            } else {
                
                let cell: HomeTableCell_NoTag = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellNoTagIndentifier, for: indexPath) as? HomeTableCell_NoTag)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                cell.lbl_title.text = data_record[indexPath.row].location!
                
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].title!)"
                cell.lbl_content.text = data_record[indexPath.row].content!
                
                if (data_record[indexPath.row].start_date! > data_record[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: data_record[indexPath.row].end_date!))"
                }
                
                return cell
            }
            
            
        // 수상경력, 자격증
        case AssetsString.CATEGORY_AWARDS, AssetsString.CATEGORY_CERTIFICATE:
            if (data_record[indexPath.row].keywords != "") {
                let cell: HomeTableCell_NoContent = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellNoContentIndentifier, for: indexPath) as? HomeTableCell_NoContent)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                cell.lbl_title.text = data_record[indexPath.row].type!
                cell.lbl_date.text = ViewManager().dateToString(date: data_record[indexPath.row].start_date! )
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].title!)"
                
                cell.keywords = ViewManager().splitString(string: data_record[indexPath.row].keywords!)
                
                cell.collection_keyword.delegate = cell
                cell.collection_keyword.dataSource = cell
                cell.collection_keyword.reloadData()
                
                
                return cell
                
            } else {
                let cell: HomeTableCell_Basic = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellBasicIndentifier, for: indexPath) as? HomeTableCell_Basic)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                cell.lbl_title.text = data_record[indexPath.row].type!
                cell.lbl_date.text = ViewManager().dateToString(date: data_record[indexPath.row].start_date!)
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].title!)"
                
                return cell
            }
            
            
        // 어학시험
        case AssetsString.CATEGORY_LANG:
            if (data_record[indexPath.row].keywords != "") {
                let cell: HomeTableCell_NoContent = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellNoContentIndentifier, for: indexPath) as? HomeTableCell_NoContent)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                cell.lbl_title.text = data_record[indexPath.row].title!
                cell.lbl_date.text = ViewManager().dateToString(date: data_record[indexPath.row].start_date!)
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].score!)"
                
                cell.keywords = ViewManager().splitString(string: data_record[indexPath.row].keywords!)
                
                cell.collection_keyword.delegate = cell
                cell.collection_keyword.dataSource = cell
                cell.collection_keyword.reloadData()
                
                return cell
                
            } else {
                let cell: HomeTableCell_Basic = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellBasicIndentifier, for: indexPath) as? HomeTableCell_Basic)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                cell.lbl_title.text = data_record[indexPath.row].title!
                cell.lbl_date.text = ViewManager().dateToString(date: data_record[indexPath.row].start_date!)
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].score!)"
                
                return cell
            }
            
            
            
        // 학력사항
        case AssetsString.CATEGORY_EDU:
            if (data_record[indexPath.row].major != "") {
                let cell: HomeTableCell_Basic = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellBasicIndentifier, for: indexPath) as? HomeTableCell_Basic)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                
                cell.lbl_title.text = data_record[indexPath.row].title!
                
                cell.lbl_subTitle.text = "\(data_record[indexPath.row].major!)"
                
                if (data_record[indexPath.row].start_date! > data_record[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: data_record[indexPath.row].end_date!))"
                }
                
                return cell
            }else {
                let cell: HomeTableCell_Title = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellTitleIdentifier, for: indexPath) as? HomeTableCell_Title)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: data_record[indexPath.row].category!))")
                
                cell.lbl_title.text = data_record[indexPath.row].title!
                
                
                if (data_record[indexPath.row].start_date! > data_record[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: data_record[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: data_record[indexPath.row].end_date!))"
                }
                return cell
            }
            
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let record: Records = CoreDataManager().getRecord(id: data_record[indexPath.row].id!)
        let category = data_record[indexPath.row].category!
        
        switch category {
        // 경력사항, 교육사항, 대외활동
        case AssetsString.CATEGORY_CAREER, AssetsString.CATEGORY_SEMINAR, AssetsString.CATEGORY_EXTRA:
            if (data_record[indexPath.row].keywords != "") {
                showEditView(vc: self, category: category, record: record)
            } else {
                showEditView(vc: self, category: category, record: record)
            }
            
            
        // 수상경력, 어학시험, 자격증
        case AssetsString.CATEGORY_AWARDS, AssetsString.CATEGORY_LANG, AssetsString.CATEGORY_CERTIFICATE:
            if (data_record[indexPath.row].keywords != "") {
                showEditView(vc: self, category: category, record: record)
                
            } else {
                showEditView(vc: self, category: category, record: record)
            }
            
        // 학력사항
        case AssetsString.CATEGORY_EDU:
            if (data_record[indexPath.row].major != "") {
                showEditView(vc: self, category: category, record: record)
            } else {
                showEditView(vc: self, category: category, record: record)
            }
        default:
            break
        }
    }
}
