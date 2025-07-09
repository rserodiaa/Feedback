//
//  MockStorageService.swift
//  Feedback
//
//  Created by Rahul Serodia on 09/07/25.
//

@testable import Feedback
import Foundation

final class MockStorageService: FeedbackStorageServiceProtocol {
    var feedbackByTitle = Feedback(id: UUID(), title: "Test Title", message: "Test Message", status: .failed,
                                   createdAt: .now, fileName: "file.txt")
    var didCreate = false
    var didDelete = false
    var didUpdate = false
    
    var feedbacks: [Feedback] = [Feedback(id: UUID(), title: "New Note", message: "New Message", status: .success,
                                          createdAt: .now, fileName: "file.txt"),
                                 Feedback(id: UUID(), title: "Fresh Note", message: "Fresh Message", status: .failed,
                                          createdAt: .now, fileName: "new.txt")]

    func fetchFeedback(by title: String) async throws -> CDFeedback? {
        // Mocking fetch found
        if title == feedbackByTitle.title {
            let context = PersistenceController.shared.container.viewContext
            let entity = CDFeedback(context: context)
            entity.id = feedbackByTitle.id
            entity.title = feedbackByTitle.title
            entity.message = feedbackByTitle.message
            entity.status = feedbackByTitle.status.rawValue
            entity.fileName = feedbackByTitle.fileName
            entity.createdAt = feedbackByTitle.createdAt
            return entity
        }
        return nil
    }

    func fetchFeedbacks() async throws -> [Feedback] {
        return feedbacks
    }

    func create(feedback: Feedback) async throws {
        didCreate = true
    }

    func update(feedback: Feedback) async throws {
        didUpdate = true
    }
    
    func delete(feedback: Feedback) async throws {
        didDelete = true
    }
    
    func fetchFailed() async throws -> [Feedback] {
        return feedbacks.filter { $0.status == .failed }
    }
}
