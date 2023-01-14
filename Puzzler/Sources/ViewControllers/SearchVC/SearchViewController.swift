//
//  SearchViewController.swift
//  Puzzler
//
//  Created by Jeeyeun Park on 2021/10/28.
//

import UIKit

class SearchViewController : UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    let collectionCellIdentifier: String = "cell_recentSearch"
 
    
    //최근 검색어
    var recentSearchList = [RecentSearchTags]()
    var searchFilters = [String]()
    //검색 결과
    var searchResults: [Records] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getRecentTags), name: NSNotification.Name(rawValue: "searchFilters"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getDateFilter), name: NSNotification.Name(rawValue: "searchFilterDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getStartDateFilter), name: NSNotification.Name(rawValue: "searchFilterStartDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getEndDateFilter), name: NSNotification.Name(rawValue: "searchFilterEndDate"), object: nil)
    
        
        getAllRecentSearchTags()
        hideKeyboard()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAllRecentSearchTags()
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    //키보드 숨기기
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func showFilter(_ sender: Any) {
        searchResults = []
        searchBar.text = ""
        
        tableView.reloadData()
    }
    
    @IBAction func showDateFilter(_ sender: Any) {
        searchResults = []
        searchBar.text = ""
        
        tableView.reloadData()
    }
    
    func getAllRecentSearchTags() {
        let tags: [RecentSearchTags] = CoreDataManager_RecentTag().getAllTags()
        self.recentSearchList = tags
        
        print(recentSearchList.count)
    }
    
    @objc func getRecentTags(_ notification: NSNotification) {
        
        let filters = notification.object as! [String]
        
        getRecordsFiltered(filters: filters)
        
        getAllRecentSearchTags()
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @objc func getDateFilter(_ notification: NSNotification) {
        let date = notification.object as! [Date]
        
        getRecordsFiltered(date: date)
        tableView.reloadData()
    }
    
    @objc func getStartDateFilter(_ notification: NSNotification) {
        
        let date_start = notification.object as! Date
        
        getRecordsFiltered(date: date_start, isBefore: false)
        tableView.reloadData()
    }
    
    @objc func getEndDateFilter(_ notification: NSNotification) {
        let date_end = notification.object as! Date
        
        getRecordsFiltered(date: date_end, isBefore: true)
        tableView.reloadData()
    }
    
    @objc func deleteRecentSearchList(_ sender : UIButton) {
        
        let id = recentSearchList[sender.tag].id
        CoreDataManager_RecentTag().deleteTags(id: id!)
        
        getAllRecentSearchTags()
        collectionView.reloadData()
        
    }
    
    @objc func searchRecentSearchList(_ sender : UIButton) {
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: sender.tag, section: 0)) as! SearchFilterCell
        
        searchBar.text = cell.btn_search.currentTitle!
        
        getRecordsFiltered(searchBar_filter: searchBar.text!)
        tableView.reloadData()
    }
    
    
    // print all career records
    func getRecordsFiltered(filters: [String]) {
        let records: [Records] = CoreDataManager.shared.getRecordsFiltered(filters: filters)
        self.searchResults = records
    }
    
    func getRecordsFiltered(searchBar_filter: String) {
        
        let records: [Records] = CoreDataManager.shared.getRecordsFiltered(searchBar_filter:  searchBar_filter)
        self.searchResults = records
    }
    
    func getRecordsFiltered(date: [Date]){
        
        let records: [Records] = CoreDataManager.shared.getRecordsFilteredByDate(date: date)
        
        self.searchResults = records
    }
    
    func getRecordsFiltered(date: Date, isBefore: Bool) {
        
        let records: [Records] = CoreDataManager.shared.getRecordsFilteredByDate(date: date, isBefore: isBefore)
        
        self.searchResults = records
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
        case AssetsString.CATEGORY_CAREER:
            setAddCareerViewLabel(vc: vc as! EditViewController, category: category, record: record)
            
        case AssetsString.CATEGORY_SEMINAR:
            setAddSeminarViewLabel(vc: vc as! EditViewController, category: category, record: record)
            
        case AssetsString.CATEGORY_EXTRA:
            setAddExtraViewLabel(vc: vc as! EditViewController, category: category, record: record)
            
        case AssetsString.CATEGORY_AWARDS:
            setAddAwardsViewLabel(vc: vc as! EditView2Controller, category: category, record: record)
            
        case AssetsString.CATEGORY_LANG:
            setAddLanguageViewLabel(vc: vc as! EditView2Controller, category: category, record: record)
            
        case AssetsString.CATEGORY_CERTIFICATE:
            setAddCertificateViewLabel(vc: vc as! EditView2Controller, category: category, record: record)
            
        case AssetsString.CATEGORY_EDU:
            setAddEduViewLabel(vc: vc as! EditView3Controller, category: category, record: record)
            
            
        default:
            break
        }
    }
    
    
    func setAddCareerViewLabel(vc: EditViewController, category: String, record: Records) {
        setNextViewLabel(vc: vc, category: category, title: "직급 및 근무 부서", date: "근무기간", startDate: "시작일", endDate: "종료일", location: "근무지", content: "업무내용")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    func setAddSeminarViewLabel(vc: EditViewController, category: String, record: Records) {
        setNextViewLabel(vc: vc, category: category, title: "교육과정명", date: "교육기간", startDate: "시작일", endDate: "종료일", location: "교육시행기관", content: "교육내용 및 사유")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    func setAddExtraViewLabel(vc: EditViewController, category: String, record: Records) {
        setNextViewLabel(vc: vc, category: category, title: "활동명", date: "활동기간", startDate: "시작일", endDate: "종료일", location: "기관/장소", content: "활동내용")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    func setAddAwardsViewLabel(vc: EditView2Controller, category: String, record: Records) {
        
        setNextView2Label(vc: vc, category: category, type: "대회명", date: "수여일자", title: "수상명", score: "수상등수", department: "수여기관")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    func setAddLanguageViewLabel(vc: EditView2Controller, category: String, record: Records) {
        
        setNextView2Label(vc: vc, category: category, type: "외국어명", date: "취득일자", title: "시험명", score: "점수", department: "평가기관")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    func setAddCertificateViewLabel(vc: EditView2Controller, category: String, record: Records) {
        setNextView2Label(vc: vc, category: category, type: "자격증명", date: "취득일자", title: "자격번호", score: "자격등급", department: "발행기관")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    func setAddEduViewLabel(vc: EditView3Controller, category: String, record: Records) {
        setNextView3Label(vc: vc, category: "학력사항")
        
        //setting edit career content
        vc.vc_record =  record
    }
    
    
    // career, seminar, extra view
    func setNextViewLabel(vc: EditViewController, category: String, title: String, date: String, startDate: String, endDate: String, location: String, content: String) {
        
        vc.vc_category = category
        vc.vc_title = title
        vc.vc_date = date
        vc.vc_dateStart = startDate
        vc.vc_dateEnd = endDate
        vc.vc_location = location
        vc.vc_content = content
    }
    
    // awards, language, certificate view
    func setNextView2Label(vc: EditView2Controller, category: String, type: String, date: String, title: String, score: String, department: String) {
        
        vc.vc_category = category
        vc.vc_type = type
        vc.vc_date = date
        vc.vc_title = title
        vc.vc_score = score
        vc.vc_department = department
        
    }
    
    // edu view
    func setNextView3Label(vc: EditView3Controller, category: String) {
        vc.vc_category = category
    }
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("recent search tag = \(recentSearchList.count)")
        return recentSearchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as? SearchFilterCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = ViewManager.CORNER_RADIUS
        
        // 태그 이름 설정
        cell.btn_search.setTitle(recentSearchList[indexPath.row].title, for: .normal)

        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(SearchViewController.deleteRecentSearchList(_:)), for: .touchUpInside)
        
        //태그 click event
        cell.btn_search.tag = indexPath.row
        cell.btn_search.addTarget(self, action: #selector(SearchViewController.searchRecentSearchList(_:)), for: .touchUpInside)
        
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 검색바에 내용 입력시 이전 검색 결과 사라지도록 구현
        searchResults = []
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != "") {
            //검색 버튼 클릭시 최근 검색 tag 추가 & 검색 내용 업데이트
            CoreDataManager_RecentTag().saveRecentTag(id: UUID().self, title: searchBar.text!, date: Date())
            
            getAllRecentSearchTags()
            collectionView.reloadData()
        }
        
        getRecordsFiltered(searchBar_filter: searchBar.text!)
        tableView.reloadData()
        
        searchBar.text = ""
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch searchResults[indexPath.row].category {
        // 경력사항, 교육사항, 대외활동
        case AssetsString.CATEGORY_CAREER, AssetsString.CATEGORY_SEMINAR, AssetsString.CATEGORY_EXTRA:
            if (searchResults[indexPath.row].keywords != "") {
                
                let cell: HomeTableCell = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellIndentifier, for: indexPath) as? HomeTableCell)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                cell.lbl_title.text = searchResults[indexPath.row].location
                cell.lbl_subTitle.text = "\(searchResults[indexPath.row].title!)"
                cell.lbl_content.text = searchResults[indexPath.row].content
                
                cell.keywords = ViewManager().splitString(string: searchResults[indexPath.row].keywords!)
                
                cell.collection_keyword.delegate = cell
                cell.collection_keyword.dataSource = cell
                
                cell.collection_keyword.reloadData()
                
                if (searchResults[indexPath.row].start_date! > searchResults[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: searchResults[indexPath.row].end_date!))"
                }
                
                return cell
                
            } else {
                let cell: HomeTableCell_NoTag = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellNoTagIndentifier, for: indexPath) as? HomeTableCell_NoTag)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                cell.lbl_title.text = searchResults[indexPath.row].location!
                
                cell.lbl_subTitle.text = "\(searchResults[indexPath.row].title!)"
                cell.lbl_content.text = searchResults[indexPath.row].content!
                
                if (searchResults[indexPath.row].start_date! > searchResults[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: searchResults[indexPath.row].end_date!))"
                }
                
                return cell
            }
            
            
        // 수상경력, 자격증
        case AssetsString.CATEGORY_AWARDS, AssetsString.CATEGORY_CERTIFICATE:
            if (searchResults[indexPath.row].keywords != "") {
                let cell: HomeTableCell_NoContent = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellNoContentIndentifier, for: indexPath) as? HomeTableCell_NoContent)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                cell.lbl_title.text = searchResults[indexPath.row].type!
                cell.lbl_date.text = ViewManager().dateToString(date: searchResults[indexPath.row].start_date! )
                cell.lbl_subTitle.text =  "\(searchResults[indexPath.row].title! )"
                
                cell.keywords = ViewManager().splitString(string: searchResults[indexPath.row].keywords!)
                
                cell.collection_keyword.delegate = cell
                cell.collection_keyword.dataSource = cell
                cell.collection_keyword.reloadData()
                
                return cell
                
            } else {
                let cell: HomeTableCell_Basic = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellBasicIndentifier, for: indexPath) as? HomeTableCell_Basic)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                cell.lbl_title.text = searchResults[indexPath.row].type!
                cell.lbl_date.text = ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)
                cell.lbl_subTitle.text =  "\(searchResults[indexPath.row].title! )"
                
                return cell
            }
            
            
        // 어학시험
        case AssetsString.CATEGORY_LANG:
            if (searchResults[indexPath.row].keywords != "") {
                let cell: HomeTableCell_NoContent = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellNoContentIndentifier, for: indexPath) as? HomeTableCell_NoContent)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                cell.lbl_title.text = searchResults[indexPath.row].title!
                cell.lbl_date.text = ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)
                cell.lbl_subTitle.text =  "\(searchResults[indexPath.row].score!)"
                
                cell.keywords = ViewManager().splitString(string: searchResults[indexPath.row].keywords!)
                
                cell.collection_keyword.delegate = cell
                cell.collection_keyword.dataSource = cell
                cell.collection_keyword.reloadData()
                
                return cell
                
            } else {
                let cell: HomeTableCell_Basic = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellBasicIndentifier, for: indexPath) as? HomeTableCell_Basic)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                cell.lbl_title.text = searchResults[indexPath.row].title!
                cell.lbl_date.text = ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)
                cell.lbl_subTitle.text =  "\(searchResults[indexPath.row].score!)"
                
                return cell
            }
            
        // 학력사항
        case AssetsString.CATEGORY_EDU:
            if (searchResults[indexPath.row].major != "") {
                let cell: HomeTableCell_Basic = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellBasicIndentifier, for: indexPath) as? HomeTableCell_Basic)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                
                cell.lbl_title.text = searchResults[indexPath.row].title!
                
                cell.lbl_subTitle.text = "\(searchResults[indexPath.row].major! )"
                
                if (searchResults[indexPath.row].start_date! > searchResults[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: searchResults[indexPath.row].end_date!))"
                }
                
                return cell
            }else {
                let cell: HomeTableCell_Title = (tableView.dequeueReusableCell(withIdentifier: AssetsString.tableCellTitleIdentifier, for: indexPath) as? HomeTableCell_Title)!
                
                cell.view_content.layer.cornerRadius = ViewManager.CORNER_RADIUS
                
                cell.image_category.image = UIImage(named: "\(ViewManager().convertCategoryToEn(category: searchResults[indexPath.row].category!))")
                
                cell.lbl_title.text = searchResults[indexPath.row].title!
                
                
                if (searchResults[indexPath.row].start_date! > searchResults[indexPath.row].end_date!)  {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) ~"
                } else {
                    cell.lbl_date.text = "\(ViewManager().dateToString(date: searchResults[indexPath.row].start_date!)) - \(ViewManager().dateToString(date: searchResults[indexPath.row].end_date!))"
                }
                return cell
            }


        default:
            break
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let record: Records = CoreDataManager().getRecord(id: searchResults[indexPath.row].id!)
        let category = record.category!
        
        switch category {
        // 경력사항, 교육사항, 대외활동
        case AssetsString.CATEGORY_CAREER, AssetsString.CATEGORY_SEMINAR, AssetsString.CATEGORY_EXTRA:
            if (record.keywords != "") {
                showEditView(vc: self, category: category, record: record)
                
            } else {
                showEditView(vc: self, category: category, record: record)
            }
            
            
        // 수상경력, 어학시험, 자격증
        case AssetsString.CATEGORY_AWARDS, AssetsString.CATEGORY_LANG, AssetsString.CATEGORY_CERTIFICATE:
            if (record.keywords != "") {
                showEditView(vc: self, category: category, record: record)
                
            } else {
                showEditView(vc: self, category: category, record: record)
            }
            
        // 학력사항
        case AssetsString.CATEGORY_EDU:
            if (record.major != "") {
                showEditView(vc: self, category: category, record: record)
            } else {
                showEditView(vc: self, category: category, record: record)
            }
            
        default:
            break
        }
    }
}
