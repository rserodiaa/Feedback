//
//  FeedbackList.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25..
//

import SwiftUI
import CoreData

struct FeedbackList: View {
    @StateObject private var viewModel = FeedbackViewModel(repository: FeedbackRepository())
    @State private var errorMessage: String?
    @State private var showErrorAlert = false
    
    var body: some View {
        VStack {
            List(viewModel.feedbacks, id: \.id) { feedback in
                Text(feedback.title)
                Text(feedback.message)
            }
            
            Button("Create Feedback") {
                Task {
                    do {
                        try await viewModel.createFeedback(title: "Another Note", message: "This is a test feedback message.")
                    } catch {
                        await MainActor.run {
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadFeedbacks()
            }
        }
        .alert("Error", isPresented: $showErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(errorMessage ?? "Something went wrong.")
        })
    }
    
    
    private func addItem() {
        withAnimation {
            
            do {
                
            } catch {
                
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            
            do {
                
            } catch {
                
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    
}
