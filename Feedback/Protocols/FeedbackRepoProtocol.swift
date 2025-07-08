//
//  FeedbackRepoProtocol.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

protocol FeedbackRepoProtocol {
    func fetchFeedbacks() async throws -> [Feedback]
    func createFeedback(with title: String, and message: String) async throws -> Feedback
    func deleteFeedback(with title: String) async throws
    func updateFeedback(with title: String, and message: String) async throws
    func syncFailedFeedbacks() async throws
}
