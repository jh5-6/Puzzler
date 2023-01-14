//
//  HomeTableCell_NoContent.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/11.
//

import Foundation
import UIKit

class HomeTableCell_NoContent : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var image_category: UIImageView!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    
    @IBOutlet weak var collection_keyword: UICollectionView!
    @IBOutlet weak var view_content: UIView!
    
    
    var keywords = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return keywords.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_keyword", for: indexPath) as? CellTag else {
            return UICollectionViewCell()
        }
        cell.btn.setTitle(keywords[indexPath.row], for: .normal) 
        return cell
    }
 
}
