//
//  FeedbackStorageServiceProtocol.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

protocol FeedbackStorageServiceProtocol {
    func fetchFeedbacks() async throws -> [Feedback]
    func createFeedback(_ model: Feedback, fileName: String)
    func updateFeedback(_ model: Feedback)
    func deleteFeedback(_ model: Feedback)
}
