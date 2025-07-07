//
//  FeedbackViewModel.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import Foundation

class FeedbackViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []
    private let repository: FeedbackRepoProtocol
    
    init(repository: FeedbackRepoProtocol) {
        self.repository = repository
    }
    
    @MainActor
    func loadFeedbacks() async {
        do {
            let allFeedbacks = try await repository.fetchFeedbacks()
            feedbacks = allFeedbacks
        } catch {
            print("ViewModel - Error fetching feedbacks: \(error)")
        }
    }
    
    func createFeedback(title: String, message: String) async throws {
        do {
            let newFeedback = try await repository.createFeedback(with: title, and: message)
            await MainActor.run {
                feedbacks.append(newFeedback)
            }
        } catch {
            print("ViewModel - Error creating feedback: \(error)")
            throw error
        }
    }
    
    func updateFeedback(title: String, message: String) async throws {
        do {
            try await repository.updateFeedback(with: title, and: message)
            await loadFeedbacks()
        } catch {
            print("ViewModel - Error updating feedback: \(error)")
            throw error
        }
    }
    
    func deleteFeedback(title: String) async throws {
        do {
            try await repository.deleteFeedback(with: title)
            await loadFeedbacks()
        } catch {
            print("ViewModel - Error deleting feedback: \(error)")
            throw error
        }
    }
    
    
    func userMessage(for error: Error) -> String {
        switch error as? FeedbackError {
        case .alreadyExists:
            return "A feedback with this title already exists."
        case .saveFailed:
            return "Could not save your feedback."
        case .notFound:
            return "Feedback not found."
        case .deleteFailed:
            return "Could not delete the feedback."
        default:
            return "An unknown error occurred."
        }
    }
}
