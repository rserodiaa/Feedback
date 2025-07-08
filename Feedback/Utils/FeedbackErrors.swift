//
//  CustomErrors.swift
//  Feedback
//
//  Created by Rahul Serodia on 07/07/25.
//

import Foundation

enum FeedbackError: LocalizedError {
    case alreadyExists
    case deleteFailed
    case notFound
    case saveFailed
    case syncFailed

    var errorDescription: String? {
        switch self {
        case .alreadyExists:
            return "A feedback with this title already exists."
        case .deleteFailed:
            return "Could not delete the feedback."
        case .saveFailed:
            return "Could not save your feedback. Please try again."
        case .notFound:
            return "Feedback not found."
        case .syncFailed:
            return "Feedback syncing failed."
        }
    }
}
