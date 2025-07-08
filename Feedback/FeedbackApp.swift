//
//  FeedbackApp.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import SwiftUI

@main
struct FeedbackApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let viewModel = FeedbackViewModel(
        repository: FeedbackRepository(
            fileService: FeedbackFileService.shared,
            storageService: FeedbackStorageService()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            FeedbackList(viewModel: viewModel)
                .task(id: scenePhase) {
                    if scenePhase == .active {
                        Task {
                            try await viewModel.syncFailedFeedbacks()
                        }
                    }
                }
        }
    }
}
