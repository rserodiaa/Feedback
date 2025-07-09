//
//  FeedbackFileServiceTests.swift
//  Feedback
//
//  Created by Rahul Serodia on 09/07/25.
//

import Testing
import Foundation
@testable import Feedback

struct FeedbackFileServiceTests {
    let fileService = FeedbackFileService.shared

    @Test
    func testSaveFeedbackToCache() async throws {
        let feedback = Feedback(id: UUID(), title: "Test", message: "Message", status: .failed, createdAt: .now, fileName: "")
        let fileName = try await fileService.save(feedback: feedback, toAzure: false)

        let expectedURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("FeedbackCache")
            .appendingPathComponent(fileName)

        #expect(FileManager.default.fileExists(atPath: expectedURL.path) == true)

        // Cleanup
        try? FileManager.default.removeItem(at: expectedURL)
    }

    @Test
    func testMoveFeedbackToAzure() async throws {
        let feedback = Feedback(id: UUID(), title: "Test", message: "Move Me", status: .failed, createdAt: .now, fileName: "")
        let fileName = try await fileService.save(feedback: feedback, toAzure: false)

        try await fileService.moveFeedbackToAzure(fileName: fileName)

        let azurePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Azure")
            .appendingPathComponent(fileName)

        #expect(FileManager.default.fileExists(atPath: azurePath.path) == true)

        // Cleanup
        try? FileManager.default.removeItem(at: azurePath)
    }

    @Test
    func testDeleteFeedbackFromAzure() async throws {
        let feedback = Feedback(id: UUID(), title: "Test", message: "Delete Me", status: .success, createdAt: .now, fileName: "")
        let fileName = try await fileService.save(feedback: feedback, toAzure: true)

        try await fileService.deleteFeedback(fileName: fileName, isAzure: true)

        let azurePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Azure")
            .appendingPathComponent(fileName)

        #expect(FileManager.default.fileExists(atPath: azurePath.path) == false)
    }
}

