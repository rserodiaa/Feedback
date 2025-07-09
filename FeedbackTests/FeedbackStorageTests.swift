//
//  FeedbackStorageTests.swift
//  Feedback
//
//  Created by Rahul Serodia on 09/07/25.
//

import Testing
import CoreData
@testable import Feedback

struct FeedbackStorageTests {
    var mockContext: NSManagedObjectContext!
    var storageService: FeedbackStorageService!

    init() throws {
        let mockContainer = NSPersistentContainer(name: "Feedback")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockContainer.persistentStoreDescriptions = [description]

        var loadError: Error?
        mockContainer.loadPersistentStores { _, error in
            loadError = error
        }

        if let error = loadError {
            throw error
        }

        mockContext = mockContainer.viewContext
        storageService = FeedbackStorageService(context: mockContext)
    }

    @Test
    func createAndFetchFeedbackByTitle() async throws {
        let feedback = Feedback(id: UUID(), title: "Test", message: "Message", status: .success, createdAt: .now, fileName: "test.txt")
        try await storageService.create(feedback: feedback)

        let fetched = try await storageService.fetchFeedback(by: "Test")
        #expect(fetched?.title == "Test")
        #expect(fetched?.message == "Message")
    }

    @Test
    func fetchFeedbacks() async throws {
        let feedback = Feedback(id: UUID(), title: "Fetch", message: "Msg", status: .success, createdAt: .now, fileName: "f.txt")
        try await storageService.create(feedback: feedback)

        let all = try await storageService.fetchFeedbacks()
        #expect(all.contains { $0.title == "Fetch" })
    }

    @Test
    func updateFeedback() async throws {
        var feedback = Feedback(id: UUID(), title: "Update", message: "Old", status: .failed, createdAt: .now, fileName: "a.txt")
        try await storageService.create(feedback: feedback)

        feedback.message = "Updated"
        feedback.status = .success
        try await storageService.update(feedback: feedback)

        let updated = try await storageService.fetchFeedback(by: "Update")
        #expect(updated?.message == "Updated")
        #expect(updated?.status == "success")
    }

    @Test
    func deleteFeedback() async throws {
        let feedback = Feedback(id: UUID(), title: "Delete", message: "Bye", status: .success, createdAt: .now, fileName: "bye.txt")
        try await storageService.create(feedback: feedback)

        try await storageService.delete(feedback: feedback)
        let deleted = try await storageService.fetchFeedback(by: "Delete")

        #expect(deleted == nil)
    }

    @Test
    func fetchFailedFeedbacks() async throws {
        let success = Feedback(id: UUID(), title: "Good", message: "Message", status: .success, createdAt: .now, fileName: "good.txt")
        let failed = Feedback(id: UUID(), title: "Bad", message: "Message", status: .failed, createdAt: .now, fileName: "bad.txt")
        try await storageService.create(feedback: success)
        try await storageService.create(feedback: failed)

        let failedOnly = try await storageService.fetchFailed()
        #expect(failedOnly.contains { $0.title == "Bad" })
        #expect(!failedOnly.contains { $0.title == "Good" })
    }
}
