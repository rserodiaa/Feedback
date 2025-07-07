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
}
