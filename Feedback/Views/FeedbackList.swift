//
//  FeedbackList.swift
//  Feedback
//
//  Created by Rahul Serodia on 04/07/25..
//

import SwiftUI

struct FeedbackList: View {
    @State private var activeSheet: FeedbackSheetData?
    @StateObject private var viewModel: FeedbackViewModel
    
    init(viewModel: FeedbackViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                        ProgressView("Loading feedbacks...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                } else {
                    List {
                        ForEach(viewModel.feedbacks) { feedback in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(feedback.title).font(.headline)
                                    Text(feedback.clippedMessage).font(.subheadline)
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
                        .onDelete(perform: deleteFeedback)
                    }
                }
            }
            .navigationTitle("Feedbacks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = FeedbackSheetData()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheetData in
                FeedbackSheetView(sheetData: sheetData) { updatedTitle, updatedMessage in
                    Task {
                        if sheetData.isEditing {
                            try await viewModel.updateFeedback(with: updatedTitle, and: updatedMessage)
                        } else {
                            try await viewModel.createFeedback(with: updatedTitle, and: updatedMessage)
                        }
                        activeSheet = nil
                    }
                } onCancel: {
                    activeSheet = nil
                }
            }
        }

        .onAppear {
            Task {
                await viewModel.loadFeedbacks()
            }
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong.")
        }
    }
    
    private func deleteFeedback(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let feedback = viewModel.feedbacks[index]
                try await viewModel.deleteFeedback(with: feedback.title)
            }
        }
    }

}

#Preview {
    FeedbackList(
        viewModel: FeedbackViewModel(
            repository: FeedbackRepository(
                fileService: FeedbackFileService.shared,
                storageService: FeedbackStorageService()
            )
        )
    )
}
