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
    
    func createFeedback(with title: String, and message: String) async throws {
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
    
    func updateFeedback(with title: String, and message: String) async throws {
        do {
            try await repository.updateFeedback(with: title, and: message)
            await loadFeedbacks()
        } catch {
            print("ViewModel - Error updating feedback: \(error)")
            throw error
        }
    }
    
    func deleteFeedback(with title: String) async throws {
        do {
            try await repository.deleteFeedback(with: title)
            await loadFeedbacks()
        } catch {
            print("ViewModel - Error deleting feedback: \(error)")
            throw error
        }
    }
}
