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
    @State private var activeSheet: FeedbackSheetData?
    @State private var isLoading = false
    
    // todo: lazy load feedbacks
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                        ProgressView("Loading feedbacks...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                } else {
                    List {
                        ForEach(viewModel.feedbacks) { feedback in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(feedback.title).font(.headline)
                                    Text(feedback.message).font(.subheadline)
                                }
                                Spacer()
                                if feedback.status == .success {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            
                            .contentShape(Rectangle())
                            .onTapGesture {
                                activeSheet = FeedbackSheetData(title: feedback.title, message: feedback.message, isEditing: true)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Feedbacks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = FeedbackSheetData(title: "", message: "", isEditing: false)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.feedbacks.isEmpty {
                        Button {
                            //TODO: Implement delete functionality
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                }
            }
            .sheet(item: $activeSheet) { sheetData in
                FeedbackSheetView(sheetData: sheetData) { updatedTitle, updatedMessage in
                    Task {
                        if sheetData.isEditing {
                            try await viewModel.updateFeedback(title: updatedTitle, message: updatedMessage)
                        } else {
                            try await viewModel.createFeedback(title: updatedTitle, message: updatedMessage)
                        }
                        activeSheet = nil
                    }
                } onCancel: {
                    activeSheet = nil
                }
            }
        }

        .onAppear {
            isLoading = true
            Task {
                await viewModel.loadFeedbacks()
                isLoading = false
            }
        }
        .alert("Error", isPresented: $showErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(errorMessage ?? "Something went wrong.")
        })
    }
}
