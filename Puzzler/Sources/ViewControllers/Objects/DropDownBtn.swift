////
////  DropDownBtn.swift
////  Buzzler
////
////  Created by Jeeyeun Park on 2021/11/11.
////
//
//import Foundation
//import UIKit
//
//class dropDownBtn: UIButton {
//
//    var dropView = dropxDownView()
//    
//    var height = NSLayoutConstraint()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        //self.backgroundColor = UIColor(named: "MainColor")
//        
//        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
//        
//        dropView.translatesAutoresizingMaskIntoConstraints = false
//
//    }
//    
//    override func didMoveToSuperview() {
//        self.superview?.addSubview(dropView)
//        self.superview?.bringSubviewToFront(dropView)
//        
//        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        height = dropView.heightAnchor.constraint(equalToConstant: 0)
//    }
//    
//    var isOpen = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isOpen == false {
//            
//            isOpen = true
//            
//            NSLayoutConstraint.deactivate([self.height])
//            self.height.constant = 150
//            NSLayoutConstraint.activate([self.height])
//            
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { self.dropView.layoutIfNeeded()}, completion: nil)
//        } else {
//            isOpen = false
//            
//            NSLayoutConstraint.deactivate([self.height])
//            self.height.constant = 0
//            NSLayoutConstraint.activate([self.height])
//            
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { self.dropView.layoutIfNeeded()}, completion: nil)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
//    
//    var dropDownOptions = [String]()
//    
//    var tableView = UITableView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.addSubview(tableView)
//        
//        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dropDownOptions.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       
//        var cell = UITableViewCell()
//        cell.textLabel?.text = dropDownOptions[indexPath.row]
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(dropDownOptions[indexPath.row])
//    }
//}
