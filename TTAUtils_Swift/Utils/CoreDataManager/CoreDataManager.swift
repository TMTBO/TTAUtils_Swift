//
//  CoreDataManager.swift
//  ReadingBlog
//
//  Created by TobyoTenma on 12/01/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
   
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
       return container
    }()
    
    private lazy var ttaPersistentContainer: TTAPersistentContainer = {
        let container = TTAPersistentContainer(name: "CoreDataDemo")
        return container
    }()
    
    /// Container `viewContext` property, Readonly
    var viewContext: NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            return ttaPersistentContainer.viewContext
        }
    }
    
    /// Container `name property, Readonly
    var name: String {
        if #available(iOS 10.0, *) {
            return persistentContainer.name
        } else {
            return ttaPersistentContainer.name
        }
    }
    
    /// Save the CoreData
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
            try viewContext.save()
        } catch {
            viewContext.rollback()
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    /// Fetch Data from CoreData
    func fetchDataWithEntity(_ name: String, predicate: NSPredicate?) -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        request.predicate = predicate
        var result = [Any]()
        do {
            result = try viewContext.fetch(request)
        } catch {
            assertionFailure("Fetch request failed: \(error)")
        }
        return result
    }
    
    /// Delete an Item at entity name
    func deleteItem(entity name: String, key: String, value: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        request.predicate = NSPredicate(format: "\(key) == %@", value)
        do {
            let fetchResult = try viewContext.fetch(request)
            _ = fetchResult.map { [weak self] in
                self?.viewContext.delete($0 as! NSManagedObject)
            }
        } catch {
            let error = error as NSError
            assertionFailure("Unresolved error \(error), \(error.userInfo)")
            return false
        }
        saveContext()
        return true
    }

    /// Delete a Entity
    func delete(entity name: String) -> Bool {
        guard let count = viewContext.persistentStoreCoordinator?.persistentStores.count, count != 0 else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        do {
            if #available(iOS 9.0, *) {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                _ = try viewContext.execute(deleteRequest)
            } else {
                let items = try viewContext.fetch(fetchRequest)
                _ = items.map { viewContext.delete($0 as! NSManagedObject) }
            }
        } catch {
            let error = error as NSError
            assertionFailure("Unresolved error \(error), \(error.userInfo)")
            return false
        }
        saveContext()
        return true
    }
    
    /// Delete all CoreData data
    func deleteAllData() -> Bool {
        guard let coordinator = viewContext.persistentStoreCoordinator else { return false }
        let url = TTAPersistentContainer.defaultDirectoryURL()?.appendingPathComponent("\(TTAPersistentContainer.getAppName() ?? name).sqlite")
        
        if #available(iOS 9.0, *) {
            try? coordinator.destroyPersistentStore(at: url!, ofType: NSSQLiteStoreType, options: nil)
            do {
                let url = TTAPersistentContainer.defaultDirectoryURL()?.appendingPathComponent("\(TTAPersistentContainer.getAppName() ?? name).sqlite")
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch {
                assertionFailure("Create NSPersistentStoreCoordinator Failed: \(error)")
                return false
            }
        } else {
            let entities = coordinator.managedObjectModel.entities
            _ = entities.map {
                guard let name = $0.name else { return }
                _ = delete(entity: name)
            }
            viewContext.reset()
        }
        saveContext()
        return true
    }
}
