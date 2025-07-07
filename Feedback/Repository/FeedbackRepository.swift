//
//  FeedbackRepository.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

import Foundation

class FeedbackRepository: FeedbackRepoProtocol {
    private let fileService: FeedbackFileServiceProtocol
    private let storageService: FeedbackStorageServiceProtocol
    
    //TODO: refactor to inject from view
    init(fileService: FeedbackFileServiceProtocol = FeedbackFileService.shared,
         storageService: FeedbackStorageServiceProtocol = FeedbackStorageService()) {
        self.fileService = fileService
        self.storageService = storageService
    }
    
    func fetchFeedbacks() async throws -> [Feedback] {
        try await storageService.fetchFeedbacks()
    }
    
    func createFeedback(title: String, message: String) async -> Feedback? {
        let id = UUID()
        let status: FeedbackStatus = Bool.random() ? .success : .failed
        let feedback = Feedback(id: id, title: title, message: message, status: status, createdAt: Date(), fileName: "")
        do {
            let fileName = try await fileService.save(feedback: feedback, toAzure: status == .success)
            let modelWithFile = Feedback(id: id, title: title, message: message, status: status, createdAt: Date(), fileName: fileName)
            storageService.create(feedback: modelWithFile)
            return modelWithFile
        } catch {
            print("Error saving feedback: \(error)")
            return nil
        }
    }
    
    func saveFeedback(_ feedback: Feedback) async throws {
        
    }
    
    func deleteFeedback(_ feedback: Feedback) async throws {
        
    }
    
    func updateFeedback(_ feedback: Feedback) async throws {
        
    }
    
}
