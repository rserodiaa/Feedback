//
//  FeedbackStorageService.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

import CoreData

final class FeedbackStorageService: FeedbackStorageServiceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetchFeedbacks() -> [Feedback] {
        let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
        let entities = (try? context.fetch(request)) ?? []
        return entities.map { Feedback(entity: $0) }
    }
    
    func createFeedback(_ model: Feedback, fileName: String) {
        let entity = CDFeedback(context: context)
        entity.id = model.id
        entity.title = model.title
        entity.message = model.message
        entity.status = model.status.rawValue
        entity.createdAt = model.createdAt
        entity.fileName = model.fileName
        PersistenceController.shared.saveContext()
    }
    
    func updateFeedback(_ model: Feedback) {
        let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", model.title as CVarArg)
        guard let entity = (try? context.fetch(request))?.first else { return }
        entity.title = model.title
        entity.message = model.message
        entity.status = model.status.rawValue
        entity.fileName = model.fileName
        PersistenceController.shared.saveContext()
    }
    
    func deleteFeedback(_ model: Feedback) {
        let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        if let entity = (try? context.fetch(request))?.first {
            context.delete(entity)
            PersistenceController.shared.saveContext()
        }
    }
    
    // todo addd to FeedbackDataServiceProtocol
    func fetchFailed() -> [Feedback] {
        let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@", FeedbackStatus.failed.rawValue)
        let entities = (try? context.fetch(request)) ?? []
        return entities.map { Feedback(entity: $0) }
    }
}
