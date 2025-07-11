//
//  Persistence.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()    

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

// Use this to create background context and inject to storage service
// to run all crud operations on background thread, also notice automaticallyMergesChangesFromParent
// property which makes sure changes in the background context are saved and merged into the main context
extension PersistenceController {
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}
