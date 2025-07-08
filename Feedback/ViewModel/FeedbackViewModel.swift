//
//  FeedbackViewModel.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import Foundation

// TODO: check later if can keep whole VM as @mainActor
class FeedbackViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false

    private let repository: FeedbackRepoProtocol
    
    init(repository: FeedbackRepoProtocol) {
        self.repository = repository
    }
    
    @MainActor
    func loadFeedbacks() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let allFeedbacks = try await repository.fetchFeedbacks()
            feedbacks = allFeedbacks
        } catch {
            print("ViewModel - Error fetching feedbacks: \(error)")
            await handle(error)
        }
    }
    
    func createFeedback(with title: String, and message: String) async throws {
        do {
            let newFeedback = try await repository.createFeedback(with: title, and: message)
            // Manually updating to avoid fetch call.
            await MainActor.run {
                feedbacks.append(newFeedback)
            }
        } catch {
            print("ViewModel - Error creating feedback: \(error)")
            await handle(error)
        }
    }
    
    func updateFeedback(with title: String, and message: String) async throws {
        do {
            try await repository.updateFeedback(with: title, and: message)
            await MainActor.run {
                if let index = feedbacks.firstIndex(where: { $0.title == title }) {
                    feedbacks[index].message = message
                }
            }
        } catch {
            print("ViewModel - Error updating feedback: \(error)")
            await handle(error)
        }
    }
    
    func deleteFeedback(with title: String) async throws {
        do {
            try await repository.deleteFeedback(with: title)
            await MainActor.run {
                feedbacks.removeAll { $0.title == title }
            }
        } catch {
            print("ViewModel - Error deleting feedback: \(error)")
            await handle(error)
        }
    }

    func syncFailedFeedbacks() async throws {
        do {
            try await repository.syncFailedFeedbacks()
            await loadFeedbacks()
        } catch {
            print("ViewModel - Error syncing feedback: \(error)")
            await handle(error)
        }
    }
    
    private func handle(_ error: Error) async {
        await MainActor.run {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? "Something went wrong."
            self.showErrorAlert = true
        }
    }
}
