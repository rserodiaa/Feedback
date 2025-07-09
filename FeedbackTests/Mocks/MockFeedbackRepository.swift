//
//  MockFeedbackRepository.swift
//  Feedback
//
//  Created by Rahul Serodia on 08/07/25.
//

import Foundation
@testable import Feedback

class MockFeedbackRepository: FeedbackRepoProtocol {
    var feedbacks: [Feedback] = []
    var shouldThrow = false
    
    init(feedbacks: [Feedback] = [], shouldThrow: Bool = false) {
        self.feedbacks = feedbacks
        self.shouldThrow = shouldThrow
    }
    
    func createFeedback(with title: String, and message: String) async throws -> Feedback {
        if shouldThrow { throw FeedbackError.saveFailed }
        let feedback = Feedback(id: UUID(), title: title, message: message, status: .success, createdAt: .now, fileName: "file.txt")
        feedbacks.append(feedback)
        return feedback
    }
    
    func fetchFeedbacks() async throws -> [Feedback] {
        if shouldThrow { throw FeedbackError.notFound }
        return feedbacks
    }
    
    func updateFeedback(with title: String, and message: String) async throws {
        if shouldThrow { throw FeedbackError.saveFailed }
        if let index = feedbacks.firstIndex(where: { $0.title == title }) {
            feedbacks[index].message = message
        }
    }
    
    func deleteFeedback(with title: String) async throws {
        if shouldThrow { throw FeedbackError.deleteFailed }
        feedbacks.removeAll { $0.title == title }
    }
    
    func syncFailedFeedbacks() async throws {
        if shouldThrow { throw FeedbackError.syncFailed }
        for i in 0..<feedbacks.count {
            if feedbacks[i].status == .failed {
                feedbacks[i].status = .success
            }
        }
    }
}
