//
//  FeedbackSheetView.swift
//  Feedback
//
//  Created by Rahul Serodia on 08/07/25.
//
import SwiftUI

struct FeedbackSheetView: View {
    @State var title: String
    @State var message: String
    let isEditing: Bool
    let onSave: (String, String) -> Void
    let onCancel: () -> Void

    init(sheetData: FeedbackSheetData, onSave: @escaping (String, String) -> Void, onCancel: @escaping () -> Void) {
        _title = State(initialValue: sheetData.title)
        _message = State(initialValue: sheetData.message)
        self.isEditing = sheetData.isEditing
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("\(isEditing ? "Edit" : "Create") Feedback")
                .font(.headline)

            Group {
                if isEditing {
                    Text(title)
                        .foregroundStyle(Color.secondary.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2))
                        )
                } else {
                    TextField("Title", text: $title)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.5))
                        )
                }
            }
            TextEditor(text: $message)
                .frame(height: 150)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.5))
                )

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                Spacer()
                Button(isEditing ? "Update" : "Add") {
                    onSave(title, message)
                }
                .disabled(title.isEmpty || message.isEmpty)
            }
        }
        .padding()
        .presentationDetents([.medium])
    }
}
