//
//  FeedbackSheetData.swift
//  Feedback
//
//  Created by Rahul Serodia on 08/07/25.
//
import Foundation

struct FeedbackSheetData: Identifiable {
    let id = UUID()
    var title: String = ""
    var message: String = ""
    var isEditing: Bool = false
}
