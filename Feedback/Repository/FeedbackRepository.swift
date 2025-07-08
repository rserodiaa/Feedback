//
//  FeedbackRepository.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

import Foundation

final class FeedbackRepository: FeedbackRepoProtocol {
    
    private let fileService: FeedbackFileServiceProtocol
    private let storageService: FeedbackStorageServiceProtocol
    
    //TODO: refactor to inject from view
    init(fileService: FeedbackFileServiceProtocol = FeedbackFileService.shared,
         storageService: FeedbackStorageServiceProtocol = FeedbackStorageService()) {
        self.fileService = fileService
        self.storageService = storageService
    }
    
    func createFeedback(with title: String, and message: String) async throws -> Feedback {
        // skip if feedback with the same title already exists
        guard try await storageService.fetchFeedback(by: title) == nil else {
            throw FeedbackError.alreadyExists
        }
        
        let id = UUID()
        let status: FeedbackStatus = Bool.random() ? .success : .failed
        let feedback = Feedback(id: id, title: title, message: message, status: status, createdAt: Date(), fileName: "")
        do {
            let fileName = try await fileService.save(feedback: feedback, toAzure: status == .success)
            let feedbackWithFile = Feedback(id: id, title: title, message: message, status: status, createdAt: Date(), fileName: fileName)
            try await storageService.create(feedback: feedbackWithFile)
            return feedbackWithFile
        } catch {
            print("Repo - Error creating feedback: \(error)")
            throw FeedbackError.saveFailed
        }
    }
    
    func fetchFeedbacks() async throws -> [Feedback] {
        try await storageService.fetchFeedbacks()
    }
    
    func updateFeedback(with title: String, and message: String) async throws {
        guard let existingEntity = try await storageService.fetchFeedback(by: title) else {
            throw FeedbackError.notFound
        }
        let status = FeedbackStatus(rawValue: existingEntity.status ?? "failed") ?? .failed
        var feedback = Feedback(from: existingEntity)
        do {
            let _ = try await fileService.save(feedback: feedback, toAzure: status == .success)
            feedback.message = message
            try await storageService.update(feedback: feedback)
        } catch {
            print("Repo - Error saving feedback: \(error)")
            throw FeedbackError.saveFailed
        }
    }
    
    func deleteFeedback(with title: String) async throws {
        guard let feedbackEntity = try await storageService.fetchFeedback(by: title),
                let fileName = feedbackEntity.fileName,
                let status = feedbackEntity.status else {
            throw FeedbackError.deleteFailed
        }
        let feedback = Feedback(from: feedbackEntity)
        do {
            try await fileService.deleteFeedback(fileName: fileName, isAzure: FeedbackStatus(rawValue: status) == .success)
            try await storageService.delete(feedback: feedback)
        } catch {
            throw FeedbackError.deleteFailed
        }

    }
}
