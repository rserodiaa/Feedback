//
//  FeedbackRepositoryTests.swift
//  Feedback
//
//  Created by Rahul Serodia on 09/07/25.
//

import Testing
import Foundation
@testable import Feedback

struct FeedbackRepositoryTests {
    @Test func testCreateFeedbackSuccess() async throws {
        let mockFileService = MockFileService()
        let mockStorageService = MockStorageService()

        let repository = FeedbackRepository(fileService: mockFileService, storageService: mockStorageService)
        let feedback = try await repository.createFeedback(with: "Mock Title", and: "Mock Message")

        #expect(feedback.title == "Mock Title")
        #expect(mockFileService.didSave)
        #expect(mockStorageService.didCreate)
    }

    @Test func testCreateFeedbackDuplicate() async throws {
        let mockFileService = MockFileService()
        let mockStorageService = MockStorageService()
        let repository = FeedbackRepository(fileService: mockFileService, storageService: mockStorageService)

        do {
            _ = try await repository.createFeedback(with: "Test Title", and: "Test Messages")
        } catch {
            #expect(error as? FeedbackError == .alreadyExists)
        }
    }

    @Test
    func testFetchFeedbacks() async throws {
        let mockFileService = MockFileService()
        let mockStorage = MockStorageService()
        let repo = FeedbackRepository(fileService: mockFileService, storageService: mockStorage)
        
        let result = try await repo.fetchFeedbacks()
        #expect(result.count == 2)
        #expect(result.first?.title == "New Note")
    }
    
    @Test
    func testUpdateFeedbackSuccess() async throws {
        let mockFileService = MockFileService()
        let mockStorage = MockStorageService()
        
        let repo = FeedbackRepository(fileService: mockFileService, storageService: mockStorage)
        try await repo.updateFeedback(with: "Test Title", and: "Updated Message")
        #expect(mockStorage.didUpdate == true)
    }
    
    @Test
    func testUpdateFeedbackNotFoundThrows() async throws {
        let mockStorage = MockStorageService()
        let mockFileService = MockFileService()
        
        let repo = FeedbackRepository(fileService: mockFileService, storageService: mockStorage)
        
        do {
            try await repo.updateFeedback(with: "Invalid", and: "Message")
        } catch {
            #expect(error is FeedbackError)
            #expect(error as? FeedbackError == .notFound)
        }
    }
    
    @Test
    func testDeleteFeedbackSuccess() async throws {
        let mockFileService = MockFileService()
        let mockStorage = MockStorageService()
        
        let repo = FeedbackRepository(fileService: mockFileService, storageService: mockStorage)
        
        try await repo.deleteFeedback(with: "Test Title")
        #expect(mockStorage.didDelete == true)
    }
    
    @Test
    func testDeleteFeedbackFailure() async throws {
        let mockStorage = MockStorageService()
        let mockFileService = MockFileService()
        
        let repo = FeedbackRepository(fileService: mockFileService, storageService: mockStorage)
        
        do {
            try await repo.deleteFeedback(with: "DoesNotExist")
        } catch {
            #expect(error is FeedbackError)
            #expect(error as? FeedbackError == .deleteFailed)
        }
    }
    
    @Test
    func testSyncFailedFeedbacks() async throws {
        let mockFileService = MockFileService()
        let mockStorage = MockStorageService()
        
        let repo = FeedbackRepository(fileService: mockFileService, storageService: mockStorage)

        try await repo.syncFailedFeedbacks()
        #expect(mockStorage.didUpdate == true)
    }
}

