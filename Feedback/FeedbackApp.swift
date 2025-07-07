//
//  FeedbackApp.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25.
//

import SwiftUI

@main
struct FeedbackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FeedbackList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
