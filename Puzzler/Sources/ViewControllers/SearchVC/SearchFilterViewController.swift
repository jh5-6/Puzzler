//
//  SearchFilterViewController.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/05.
//

import Foundation
import UIKit

class SearchFilterViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var view_filter: UIView!
    @IBOutlet weak var collectionView_category: UICollectionView!
    @IBOutlet weak var collectionView_keyword: UICollectionView!
    
    var filterCellList = [CellTag]()
    var filters = [String]()
    
    let cellKeywordIndentifier: String = "cell_keyword"
    let cellCategoryIndentifier: String = "cell_category"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(view_filter)
        
        view_filter.addSubview(collectionView_category)
        view_filter.addSubview(collectionView_keyword)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("filters = \(filters)")
        
        super.viewWillAppear(animated)
        
        collectionView_keyword.reloadData()
        collectionView_category.reloadData()
    }
    
    
    @IBAction func btn_cancel(_ sender: Any) {
        //현재 페이지 닫기
        ViewManager().dissmissWindow(vc: self)
    }
    
    @IBAction func btn_ok(_ sender: Any) {
        //filter 적용
        let filter = ViewManager().getKeywords(cellKeywordList: filterCellList)
        let filters = ViewManager().splitString(string: filter)
       
        if (filters[0] != "") {
            for tag in filters {

                let id = UUID().self
                let date = Date()
        
                CoreDataManager_RecentTag().saveRecentTag(id: id, title: tag, date: date)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchFilters"), object: filters)
        }
        ViewManager().dissmissWindow(vc: self)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView_category {
            return AssetsString.CATEGORY.count
        } else {
            return AssetsString.KEYWORD.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionView_category {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_category", for: indexPath) as? CellTag else {
                return UICollectionViewCell()
            }
            
            cell.btn.setTitle(AssetsString.CATEGORY[indexPath.row], for: .normal)
           
            
            for filter in filters {
                if (cell.btn.currentTitle == filter) {
                    cell.isTagged = true
                    cell.backgroundColor =  UIColor(named: "MainColor")
                    cell.originalColor = UIColor(named: "MainBackground")
                }
            }
            
            cell.layer.cornerRadius = ViewManager.CORNER_RADIUS
            filterCellList.append(cell)
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_keyword", for: indexPath) as? CellTag else {
                return UICollectionViewCell()
            }
            cell.btn.setTitle(AssetsString.KEYWORD[indexPath.row], for: .normal)
            
            for filter in filters {
                if cell.btn.currentTitle == filter {
                    cell.isTagged = true
                    cell.backgroundColor =  UIColor(named: "MainColor")
                    cell.originalColor = UIColor(named: "LightOrange")
                }
            }
            
            cell.layer.cornerRadius = ViewManager.CORNER_RADIUS
            filterCellList.append(cell)
            
            return cell
        }
    }
}
