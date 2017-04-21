//
//  TTAPersistentContainer.swift
//  CoreDataDemo
//
//  Created by TobyoTenma on 19/04/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import Foundation
import CoreData

/// CoreData Stack before iOS 10.0
open class TTAPersistentContainer : NSObject {
    
    open class func defaultDirectoryURL() -> URL? {
        guard let dicPath = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask,
            true
            ).first else { return nil }
        var path = dicPath
        path.append("/Application Support")
        guard FileManager.default.fileExists(atPath: path) else {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Create Dictionary DB Failed: \(error)")
                return nil
            }
            var url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
            url?.appendPathComponent("Application Support")
            return url
        }
        var url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        url?.appendPathComponent("Application Support")
        return url
    }
    
    open private(set) var name: String
    
    open private(set) var viewContext: NSManagedObjectContext
    
    open private(set) var managedObjectModel: NSManagedObjectModel
    
    open private(set) var persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    // Creates a container using the model named `name` in the main bundle
    public convenience init(name: String) {
        
        let modelURL = Bundle.main.url(forResource: TTAPersistentContainer.getAppName() ?? name, withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)!
        self.init(name: name, managedObjectModel: managedObjectModel)
        self.managedObjectModel = managedObjectModel
    }
    
    public init(name: String, managedObjectModel model: NSManagedObjectModel) {
        self.name = name
        self.managedObjectModel = model
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let url = TTAPersistentContainer.defaultDirectoryURL()?.appendingPathComponent("\(TTAPersistentContainer.getAppName() ?? name).sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            fatalError("Create NSPersistentStoreCoordinator Failed: \(error)")
        }
        persistentStoreCoordinator = coordinator
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        self.viewContext = context
        
        super.init()
    }
    
    open func newBackgroundContext() -> NSManagedObjectContext {
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return privateManagedObjectContext
    }
    
    open func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Swift.Void) {
        block(newBackgroundContext())
    }
}

extension TTAPersistentContainer {
    
    static func getAppName() -> String? {
        let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"]
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"]
        let appName = (displayName == nil ? bundleName : displayName) as? String
        return appName
    }
}

