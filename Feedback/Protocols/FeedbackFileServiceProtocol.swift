//
//  FeedbackFileServiceProtocol.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

protocol FeedbackFileServiceProtocol {
    func save(feedback: Feedback, toAzure: Bool) async throws -> String
    func moveFeedbackToAzure(fileName: String) async throws
    func deleteFeedback(fileName: String, isAzure: Bool) async throws
}
