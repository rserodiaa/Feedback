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
        return entities.map { Feedback(from: $0) }
    }
    
    func create(feedback: Feedback) {
        let entity = CDFeedback(context: context)
        entity.id = feedback.id
        entity.title = feedback.title
        entity.message = feedback.message
        entity.status = feedback.status.rawValue
        entity.createdAt = feedback.createdAt
        entity.fileName = feedback.fileName
        PersistenceController.shared.saveContext()
    }
    
    func update(feedback: Feedback) {
        let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", feedback.title as CVarArg)
        guard let entity = (try? context.fetch(request))?.first else { return }
        entity.title = feedback.title
        entity.message = feedback.message
        entity.status = feedback.status.rawValue
        entity.fileName = feedback.fileName
        PersistenceController.shared.saveContext()
    }
    
    func delete(feedback: Feedback) {
        let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", feedback.id as CVarArg)
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
        return entities.map { Feedback(from: $0) }
    }
}
