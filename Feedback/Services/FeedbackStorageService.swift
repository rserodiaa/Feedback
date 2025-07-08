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

    func fetchFeedback(by title: String) async throws -> CDFeedback? {
        try await context.perform {
            let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
            request.predicate = NSPredicate(format: "title == %@", title as CVarArg)
            request.fetchLimit = 1
            return try self.context.fetch(request).first
        }
    }
    
    func fetchFeedbacks() async throws -> [Feedback] {
        try await context.perform {
            let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
            let entities = (try self.context.fetch(request))
            return entities.map { Feedback(from: $0) }
        }
    }
    
    func create(feedback: Feedback) async throws {
        try await context.perform {
            let entity = CDFeedback(context: self.context)
            entity.id = feedback.id
            entity.title = feedback.title
            entity.message = feedback.message
            entity.status = feedback.status.rawValue
            entity.createdAt = feedback.createdAt
            entity.fileName = feedback.fileName
            try PersistenceController.shared.saveContext()
        }
    }
    
    func update(feedback: Feedback) async throws {
        guard let entity = try await fetchFeedback(by: feedback.title) else { return }
        try await context.perform {
            entity.message = feedback.message
            entity.status = feedback.status.rawValue
            entity.fileName = feedback.fileName
            try PersistenceController.shared.saveContext()
        }
    }
    
    func delete(feedback: Feedback) async throws {
        try await context.perform {
            let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", feedback.id as CVarArg)
            if let entity = try self.context.fetch(request).first {
                self.context.delete(entity)
                try PersistenceController.shared.saveContext()
            }
        }
    }
    
    func fetchFailed() async throws -> [Feedback] {
        try await context.perform {
            let request: NSFetchRequest<CDFeedback> = CDFeedback.fetchRequest()
            request.predicate = NSPredicate(format: "status == %@", FeedbackStatus.failed.rawValue)
            let entities = try self.context.fetch(request)
            return entities.map { Feedback(from: $0) }
        }
    }
}
