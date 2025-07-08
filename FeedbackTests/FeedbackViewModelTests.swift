//
//  FeedbackViewModelTests.swift
//  Feedback
//
//  Created by Rahul Serodia on 08/07/25.
//

import Testing
import Foundation
@testable import Feedback

struct FeedbackViewModelTests {
    private var mockedFeedbacks: [Feedback]!
    
    init() {
        mockedFeedbacks = [
            Feedback(id: UUID(), title: "New Note", message: "New Message", status: .success, createdAt: .now, fileName: "file.txt"),
            Feedback(id: UUID(), title: "Fresh Note", message: "Fresh Message", status: .failed, createdAt: .now, fileName: "new.txt")
        ]
    }
    
    @Test
    func createFeedbackSuccess() async throws {
        let mockRepo = MockFeedbackRepository(feedbacks: mockedFeedbacks)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        await viewModel.loadFeedbacks()
        try await viewModel.createFeedback(with: "New", and: "Hello")
        
        #expect(viewModel.feedbacks.count == 3)
        #expect(viewModel.feedbacks.last?.title == "New")
    }
    
    @Test
    func createFeedbackFailure() async throws {
        let mockRepo = MockFeedbackRepository(feedbacks: mockedFeedbacks, shouldThrow: true)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        try? await viewModel.createFeedback(with: "Failed", and: "Bad desc")
        
        #expect(viewModel.feedbacks.count == 0)
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.errorMessage == "Could not save your feedback. Please try again.")
    }
    
    @Test
    func loadFeedbacksSuccess() async throws {
        let mockRepo = MockFeedbackRepository(feedbacks: mockedFeedbacks)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        await viewModel.loadFeedbacks()
        
        #expect(viewModel.feedbacks.count == 2)
        #expect(viewModel.feedbacks.first?.title == "New Note")
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test
    func loadFeedbacksFailure() async throws {
        let mockRepo = MockFeedbackRepository(shouldThrow: true)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        await viewModel.loadFeedbacks()
        
        #expect(viewModel.feedbacks.isEmpty)
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.errorMessage == "Feedback not found.")
    }
    
    @Test
    func updateFeedbackSuccess() async throws {
        let mockRepo = MockFeedbackRepository(feedbacks: mockedFeedbacks)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        await viewModel.loadFeedbacks()
        try await viewModel.updateFeedback(with: "Fresh Note", and: "Fresh Message Updated")
        
        #expect(viewModel.feedbacks.count == 2)
        #expect(viewModel.feedbacks.last?.title == "Fresh Note")
        #expect(viewModel.feedbacks.last?.message == "Fresh Message Updated")
    }
    
    @Test
    func updateFeedbackFailure() async throws {
        let mockRepo = MockFeedbackRepository(shouldThrow: true)
        let viewModel = FeedbackViewModel(repository: mockRepo)

        try await viewModel.updateFeedback(with: "Fresh Note", and: "Fresh Message Updated")
        
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.errorMessage == "Could not save your feedback. Please try again.")
    }
    
    @Test
    func deleteFeedbackSuccess() async throws {
        let mockRepo = MockFeedbackRepository(feedbacks: mockedFeedbacks)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        await viewModel.loadFeedbacks()
        try await viewModel.deleteFeedback(with: "Fresh Note")
        
        #expect(viewModel.feedbacks.count == 1)
        #expect(viewModel.feedbacks.first?.title == "New Note")
        #expect(viewModel.feedbacks.first?.message == "New Message")
    }
    
    @Test
    func deleteFeedbackFailure() async throws {
        let mockRepo = MockFeedbackRepository(shouldThrow: true)
        let viewModel = FeedbackViewModel(repository: mockRepo)

        try await viewModel.deleteFeedback(with: "Fresh Note")
        
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.errorMessage == "Could not delete the feedback.")
    }
    
    @Test
    func syncFailedFeedbacksSuccess() async throws {
        let mockRepo = MockFeedbackRepository(feedbacks: mockedFeedbacks)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        
        await viewModel.loadFeedbacks()
        #expect(viewModel.feedbacks.count == 2)
        #expect(viewModel.feedbacks.count(where: { $0.status == .failed }) == 1)
        
        try? await viewModel.syncFailedFeedbacks()
        #expect(viewModel.feedbacks.count == 2)
        #expect(viewModel.feedbacks.count(where: { $0.status == .failed }) == 0)
    }
    
    @Test
    func syncFailedFeedbacksFailure() async throws {
        let mockRepo = MockFeedbackRepository(shouldThrow: true)
        let viewModel = FeedbackViewModel(repository: mockRepo)
        try? await viewModel.syncFailedFeedbacks()
        #expect(viewModel.showErrorAlert == true)
        #expect(viewModel.errorMessage == "Feedback syncing failed.")
    }
}
