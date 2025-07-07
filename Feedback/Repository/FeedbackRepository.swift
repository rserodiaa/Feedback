//
//  FeedbackRepository.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

class FeedbackRepository: FeedbackRepoProtocol {
    private let fileService: FeedbackFileServiceProtocol
    private let storageService: FeedbackStorageServiceProtocol
    
    // refactor to inject from view
    init(fileService: FeedbackFileServiceProtocol = FeedbackFileService.shared,
         storageService: FeedbackStorageServiceProtocol = FeedbackStorageService()) {
        self.fileService = fileService
        self.fileService.setupDirectories()
        self.storageService = storageService
    }
    
    func fetchFeedbacks() async throws -> [Feedback] {
        try await storageService.fetchFeedbacks()
    }
    
    func saveFeedback(_ feedback: Feedback) async throws {
        
    }
    
    func deleteFeedback(_ feedback: Feedback) async throws {
        
    }
    
    func updateFeedback(_ feedback: Feedback) async throws {
        
    }
    
}
