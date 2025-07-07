//
//  FeedbackRepoProtocol.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

protocol FeedbackRepoProtocol {
    func fetchFeedbacks() async throws -> [Feedback]
    func saveFeedback(_ feedback: Feedback) async throws
    func deleteFeedback(_ feedback: Feedback) async throws
    func updateFeedback(_ feedback: Feedback) async throws
}
