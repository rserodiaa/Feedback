//
//  FeedbackService.swift
//  Feedback
//
//  Created by Rahul Serodia on 05/07/25.
//

import Foundation

final class FeedbackFileService: FeedbackFileServiceProtocol {
    //TODO: Can replace singleton with actors if needed, fine for current use case.
    static let shared = FeedbackFileService()
    private let fileManager = FileManager.default
    
    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    private var azureURL: URL { documentsURL.appendingPathComponent("Azure") }
    private var cacheURL: URL { documentsURL.appendingPathComponent("FeedbackCache") }
    
    private init() {
        try? fileManager.createDirectory(at: azureURL, withIntermediateDirectories: true)
        try? fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }

    func save(feedback: Feedback, toAzure: Bool) async throws -> String {
        let dir = toAzure ? azureURL : cacheURL
        let fileName = "\(feedback.id.uuidString).txt"
        let fileURL = dir.appendingPathComponent(fileName)
        let content = "Title: \(feedback.title)\nMessage: \(feedback.message)"
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileName
    }
    
    func moveFeedbackToAzure(fileName: String) async throws {
        let fromURL = cacheURL.appendingPathComponent(fileName)
        let toURL = azureURL.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: fromURL.path) {
            try fileManager.moveItem(at: fromURL, to: toURL)
        }
    }
    
    func deleteFeedback(fileName: String, isAzure: Bool) async throws {
        let dir = isAzure ? azureURL : cacheURL
        let fileURL = dir.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
}
