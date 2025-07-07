//
//  Persistence.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()    

//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "Feedback")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
    private init() { }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Feedback")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error in PersistenceController \(nserror), \(nserror.userInfo)")
                throw error
            }
        }
    }
}
