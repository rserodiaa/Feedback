//
//  FeedbackSheetView.swift
//  Feedback
//
//  Created by Rahul Serodia on 08/07/25.
//
import SwiftUI

struct FeedbackSheetView: View {
    @Binding var sheetData: FeedbackSheetData
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("\(sheetData.isEditing ? "Edit" : "Create") Feedback")
                .font(.headline)

            Group {
                if sheetData.isEditing {
                    Text(sheetData.title)
                        .foregroundStyle(Color.secondary.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2))
                        )
                } else {
                    TextField("Title", text: $sheetData.title)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.5))
                        )
                }
            }
            TextEditor(text: $sheetData.message)
                .frame(height: 150)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.5))
                )

            HStack {
                Button("Cancel") { dismiss() }
                Spacer()
                Button(sheetData.isEditing ? "Update" : "Add") { dismiss() }
                    .disabled(sheetData.title.isEmpty || sheetData.message.isEmpty)
            }
        }
        .padding()
        .presentationDetents([.medium])
    }
}
