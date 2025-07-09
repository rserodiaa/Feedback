//
//  MockFileService.swift
//  Feedback
//
//  Created by Rahul Serodia on 09/07/25.
//

@testable import Feedback

final class MockFileService: FeedbackFileServiceProtocol {
    var didSave = false
    
    func save(feedback: Feedback, toAzure: Bool) async throws -> String {
        didSave = true
        return "\(feedback.id).txt"
    }

    func moveFeedbackToAzure(fileName: String) async throws {}
    func deleteFeedback(fileName: String, isAzure: Bool) async throws {}
}
