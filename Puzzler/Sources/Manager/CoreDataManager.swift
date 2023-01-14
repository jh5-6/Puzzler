//
//  CoreDataManager.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/11/05.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    let search_attr = ["category", "content", "grades_major", "grades_total", "id", "keywords", "location", "major", "minor", "memo", "score", "title", "type"]
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var ctx = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Records"
    
    // id를 통해 해당 레코드 가져오기
    func getRecord(ascending: Bool = false, id: String) -> Records {
        
        var model: Records = Records()
        
        if let ctx = ctx {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredByIdRequest(id: id)
            do {
                let fetchResult = try ctx.fetch(fetchRequest) as! [NSManagedObject]
                if let record = fetchResult.first as? Records {
                    model = record
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
        
        return model
    }
    
    //모든 레코드 가져오기
    func getAllRecords(ascending: Bool = false) -> [Records] {
        var models: [Records] = [Records]()
        
        if let ctx = ctx{
            let recordsSort: NSSortDescriptor = NSSortDescriptor(key: "start_date", ascending: true)
            let fetchRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [recordsSort]
            
            do {
                if let fetchResult: [Records] = try ctx.fetch(fetchRequest) as? [Records] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
    
        return models
    }
    
    //필터링한 레코드 가져오기
    //필터 적용
    func getRecordsFiltered(ascending: Bool = false, filters: [String]) -> [Records] {
        var models: [Records] = [Records]()
        
        if let ctx = ctx {
            let recordsSort: NSSortDescriptor = NSSortDescriptor(key: "start_date", ascending: true)
            //레코드 항목 중에 필터 내용이 담긴 경우 해당 레코드 불러오기
            for search in search_attr {
                for filter in filters {
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(filter: search, data: filter)
                    fetchRequest.sortDescriptors = [recordsSort]
                    do {
                        if let fetchResult: [Records] = try ctx.fetch(fetchRequest) as? [Records] {
                            models.append(contentsOf: fetchResult)
                        }
                    } catch let error as NSError {
                        print("Could not fetch: \(error), \(error.userInfo)")
                    }
                }
            }                
        }
        models = removeDuplicateRecord(models)
        models.sort(by: {$0.start_date! < $1.start_date!})
        return models
    }
    
    //검색창 필터링
    func getRecordsFiltered(ascending: Bool = false, searchBar_filter: String) -> [Records] {
        
        //필터 키워드 + 검색창 내용 합쳐서 하나의 필터 만들기
        let filter = [searchBar_filter]
        
        let models = getRecordsFiltered(filters: filter)
        
        return models
    }
    
    //날짜 필터링
    func getRecordsFilteredByDate(ascending: Bool = false, date: Date, isBefore: Bool) -> [Records] {
        var models: [Records] = [Records]()
        
        if let ctx = ctx {
            let recordsSort: NSSortDescriptor = NSSortDescriptor(key: "start_date", ascending: true)
            //레코드 항목 중에 필터 내용이 담긴 경우 해당 레코드 불러오기
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredByDateRequest(date: date, isBefore: isBefore)
            fetchRequest.sortDescriptors = [recordsSort]
            do {
                if let fetchResult: [Records] = try ctx.fetch(fetchRequest) as? [Records] {
                    models.append(contentsOf: fetchResult)
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
 
        models = removeDuplicateRecord(models)
        return models
    }
    
    func getRecordsFilteredByDate(ascending: Bool = false, date: [Date]) -> [Records] {
        var models: [Records] = [Records]()
        
        if let ctx = ctx {
            let recordsSort: NSSortDescriptor = NSSortDescriptor(key: "start_date", ascending: true)
            //레코드 항목 중에 필터 내용이 담긴 경우 해당 레코드 불러오기
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredByDateRequest(date: date)
            fetchRequest.sortDescriptors = [recordsSort]
            do {
                if let fetchResult: [Records] = try ctx.fetch(fetchRequest) as? [Records] {
                    models.append(contentsOf: fetchResult)
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
 
        models = removeDuplicateRecord(models)
        return models
    }
    
    
    // 중복 레코드 삭제
    func removeDuplicateRecord(_ array: [Records]) -> [Records] {
        var removedArray = [Records]()
        
        for i in array {
            if removedArray.contains(i) == false {
                removedArray.append(i)
            }
        }
        return removedArray
    }
    
    
    ///레코드 저장
    func saveRecords(id: String, category: String, title:String, start_date: Date, end_date: Date, location: String, type: String, score: String, major: String, minor: String, grades_total: String, grades_major: String, content: String, memo: String, keywords: String, images: [Data]) {
        if let ctx = ctx,
           let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: ctx) {
            if let record: Records = NSManagedObject(entity: entity, insertInto: ctx) as? Records {
                
                //                record.setValue(id, forKey: "id")
                record.id = id
                record.category = category
                record.title = title
                record.start_date = start_date
                record.end_date = end_date
                record.location = location
                record.type = type
                record.score = score
                record.major = major
                record.minor = minor
                record.grades_total = grades_total
                record.grades_major = grades_major
                record.content = content
                record.memo = memo
                record.keywords = keywords
                record.images = images 
                
                do {
                    try ctx.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // 레코드 업데이트 
    func updateRecords(id: String, category: String, title:String, start_date: Date, end_date: Date, location: String, type: String, score: String, major: String, minor: String, grades_total: String, grades_major: String, content: String, memo: String, keywords: String, images: [Data]) {
        
        let record = getRecord(id: id)
        
        record.id = id
        record.category = category
        record.title = title
        record.start_date = start_date
        record.end_date = end_date
        record.location = location
        record.type = type
        record.score = score
        record.major = major
        record.minor = minor
        record.grades_total = grades_total
        record.grades_major = grades_major
        record.content = content
        record.memo = memo
        record.keywords = keywords
        record.images = images 
        
        do {
            try ctx!.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //레코드 삭제
    func deleteRecords(id: String) {
        if let ctx = ctx {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredByIdRequest(id: id)
            do {
                let fetchResult = try ctx.fetch(fetchRequest) as! [NSManagedObject]
                if let record = fetchResult.first as? Records {
                    //            if let fe: [Records] = try ctx?.fetch(fetchRequest) as? [Records] {
                    ctx.delete(record)
                }
                
                do {
                    try ctx.save()
                } catch {
                    print(error.localizedDescription)
                }
                
            } catch let error as NSError {
                print("could not fetch: \(error) \(error.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
    fileprivate func filteredRequest(filter: String, data: String) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        fetchRequest.predicate = NSPredicate(format: "\(filter) CONTAINS %@", data)
        
        return fetchRequest
    }
    
    fileprivate func filteredByDateRequest(date: Date, isBefore: Bool) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        if (isBefore) {
            fetchRequest.predicate = NSPredicate(format: "start_date <= %@", date as NSDate)
        } else {
            fetchRequest.predicate = NSPredicate(format: "start_date >= %@", date as NSDate)
        }
        
        return fetchRequest
        
    }
    
    fileprivate func filteredByDateRequest(date: [Date]) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        let predicate1 = NSPredicate(format: "start_date >= %@", date[0] as NSDate)
        let predicate2 = NSPredicate(format: "start_date <= %@", date[1] as NSDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        return fetchRequest
        
    }
    
    fileprivate func filteredByIdRequest(id: String) -> NSFetchRequest<NSFetchRequestResult> {
        print("filter: \(id)")
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", id)
        
        return fetchRequest
    }
    
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try ctx?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("could not save: \(error) \(error.userInfo)")
            onSuccess(false)
        }
    }
}
