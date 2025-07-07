//
//  FeedbackStorageServiceProtocol.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

protocol FeedbackStorageServiceProtocol {
    func fetchFeedbacks() async throws -> [Feedback]
    func create(feedback: Feedback)
    func update(feedback: Feedback)
    func delete(feedback: Feedback)
}
