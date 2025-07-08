//
//  FeedbackStorageServiceProtocol.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

protocol FeedbackStorageServiceProtocol {
    func fetchFeedback(by title: String) async throws -> CDFeedback?
    func fetchFeedbacks() async throws -> [Feedback]
    func create(feedback: Feedback) async throws
    func update(feedback: Feedback) async throws
    func delete(feedback: Feedback) async throws
    func fetchFailed() async throws -> [Feedback]
}
