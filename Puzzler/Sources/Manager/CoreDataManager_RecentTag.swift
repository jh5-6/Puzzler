//
//  CoreDataManager_RecentTag.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/28.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager_RecentTag {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var ctx = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "RecentSearchTags"
    
    //모든 레코드 가져오기
    func getAllTags(ascending: Bool = false) -> [RecentSearchTags] {
        var models: [RecentSearchTags] = [RecentSearchTags]()
        
        if let ctx = ctx{
            let recordsSort: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let fetchRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [recordsSort]
            
            do {
                if let fetchResult: [RecentSearchTags] = try ctx.fetch(fetchRequest) as? [RecentSearchTags] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    ///레코드 저장
    func saveRecentTag(id: UUID, title:String, date: Date) {
        if let ctx = ctx,
           let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: ctx) {
            if let tag: RecentSearchTags = NSManagedObject(entity: entity, insertInto: ctx) as? RecentSearchTags {
                
                tag.id = id
                tag.title = title
                tag.date = date
       
                do {
                    try ctx.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //레코드 삭제
    func deleteTags(id: UUID) {
        if let ctx = ctx {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredByIdRequest(id: id)
            do {
                let fetchResult = try ctx.fetch(fetchRequest) as! [NSManagedObject]
                if let tag = fetchResult.first as? RecentSearchTags {
                    //            if let fe: [Records] = try ctx?.fetch(fetchRequest) as? [Records] {
                    ctx.delete(tag)
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

extension CoreDataManager_RecentTag {
    
    fileprivate func filteredByIdRequest(id: UUID) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
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
