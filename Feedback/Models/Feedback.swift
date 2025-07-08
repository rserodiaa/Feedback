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
    
    init(id: UUID, title: String, message: String, status: FeedbackStatus, createdAt: Date, fileName: String) {
        self.id = id
        self.title = title
        self.message = message
        self.status = status
        self.createdAt = createdAt
        self.fileName = fileName
    }
    
    init(from entity: CDFeedback) {
        self.init(id: entity.id ?? UUID(),
                  title: entity.title ?? "",
                  message: entity.message ?? "",
                  status: FeedbackStatus(rawValue: entity.status ?? "failed") ?? .failed,
                  createdAt: entity.createdAt ?? Date(),
                  fileName: entity.fileName ?? "")
    }
    
    var clippedMessage: String {
        return message.truncated(to: 100)
    }
}
