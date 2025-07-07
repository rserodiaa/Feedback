//
//  Feedback.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import Foundation

enum FeedbackStatus: String {
    case success, failed
}

struct Feedback: Identifiable {
    var id: UUID
    var title: String
    var message: String
    var status: FeedbackStatus
    var createdAt: Date
    var fileName: String
    
    init(entity: CDFeedback) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.message = entity.message ?? ""
        self.status = FeedbackStatus(rawValue: entity.status ?? "failed") ?? .failed
        self.createdAt = entity.createdAt ?? Date()
        self.fileName = entity.fileName ?? ""
    }
}
