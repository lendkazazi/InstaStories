//
//  StoryRepositoryTests.swift
//  InstaStoriesTests
//
//  Created by Lend Kazazi on 12/10/25.
//

import XCTest
@testable import InstaStories

final class StoryRepositoryTests: XCTestCase {
    var mockRepository: MockStoryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockStoryRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Stories Tests
    
    func testFetchStories_Success() async throws {
        // Given
        let expectedStories = MockStoryRepository.makeMockStories(count: 10)
        mockRepository.fetchStoriesResult = .success(expectedStories)
        
        // When
        let stories = try await mockRepository.fetchStories(page: 1, limit: 10)
        
        // Then
        XCTAssertEqual(stories.count, 10)
        XCTAssertTrue(mockRepository.fetchStoriesCalled)
        XCTAssertEqual(mockRepository.lastFetchedPage, 1)
        XCTAssertEqual(mockRepository.lastFetchedLimit, 10)
    }
    
    func testFetchStories_Failure() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When/Then
        do {
            _ = try await mockRepository.fetchStories(page: 1, limit: 10)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RepositoryError)
        }
    }
    
    func testFetchStories_Pagination() async throws {
        // Given
        let page1Stories = MockStoryRepository.makeMockStories(count: 20)
        let page2Stories = MockStoryRepository.makeMockStories(count: 20)
        
        // When - Fetch page 1
        mockRepository.fetchStoriesResult = .success(page1Stories)
        let firstPage = try await mockRepository.fetchStories(page: 1, limit: 20)
        
        // When - Fetch page 2
        mockRepository.fetchStoriesResult = .success(page2Stories)
        let secondPage = try await mockRepository.fetchStories(page: 2, limit: 20)
        
        // Then
        XCTAssertEqual(firstPage.count, 20)
        XCTAssertEqual(secondPage.count, 20)
        XCTAssertEqual(mockRepository.lastFetchedPage, 2)
    }
    
    // MARK: - Story State Tests
    
    func testGetStoryState_WhenStateExists() async {
        // Given
        let storyId = "story_1"
        let expectedState = StoryState(
            storyId: storyId,
            isSeen: true,
            isLiked: true
        )
        mockRepository.storyStates[storyId] = expectedState
        
        // When
        let state = await mockRepository.getStoryState(storyId: storyId)
        
        // Then
        XCTAssertEqual(state.storyId, storyId)
        XCTAssertTrue(state.isSeen)
        XCTAssertTrue(state.isLiked)
    }
    
    func testGetStoryState_WhenStateDoesNotExist() async {
        // Given
        let storyId = "story_999"
        
        // When
        let state = await mockRepository.getStoryState(storyId: storyId)
        
        // Then - should return default state
        XCTAssertEqual(state.storyId, storyId)
        XCTAssertFalse(state.isSeen)
        XCTAssertFalse(state.isLiked)
        XCTAssertNil(state.lastSeenAt)
    }
    
    func testUpdateStoryState_Success() async throws {
        // Given
        let storyId = "story_1"
        let state = StoryState(
            storyId: storyId,
            isSeen: true,
            isLiked: false
        )
        
        // When
        try await mockRepository.updateStoryState(state)
        
        // Then
        let retrievedState = await mockRepository.getStoryState(storyId: storyId)
        XCTAssertTrue(retrievedState.isSeen)
        XCTAssertFalse(retrievedState.isLiked)
    }
    
    func testUpdateStoryState_Failure() async {
        // Given
        mockRepository.shouldThrowError = true
        let state = StoryState(storyId: "story_1")
        
        // When/Then
        do {
            try await mockRepository.updateStoryState(state)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is RepositoryError)
        }
    }
    
    // MARK: - Mark As Seen Tests
    
    func testMarkAsSeen() async throws {
        // Given
        let storyId = "story_1"
        
        // When
        try await mockRepository.markAsSeen(storyId: storyId)
        
        // Then
        XCTAssertTrue(mockRepository.markAsSeenCalled)
        let state = await mockRepository.getStoryState(storyId: storyId)
        XCTAssertTrue(state.isSeen)
        XCTAssertNotNil(state.lastSeenAt)
    }
    
    // MARK: - Toggle Like Tests
    
    func testToggleLike_FromUnlikedToLiked() async throws {
        // Given
        let storyId = "story_1"
        mockRepository.storyStates[storyId] = StoryState(
            storyId: storyId,
            isLiked: false
        )
        
        // When
        try await mockRepository.toggleLike(storyId: storyId)
        
        // Then
        XCTAssertTrue(mockRepository.toggleLikeCalled)
        let state = await mockRepository.getStoryState(storyId: storyId)
        XCTAssertTrue(state.isLiked)
    }
    
    func testToggleLike_FromLikedToUnliked() async throws {
        // Given
        let storyId = "story_1"
        mockRepository.storyStates[storyId] = StoryState(
            storyId: storyId,
            isLiked: true
        )
        
        // When
        try await mockRepository.toggleLike(storyId: storyId)
        
        // Then
        let state = await mockRepository.getStoryState(storyId: storyId)
        XCTAssertFalse(state.isLiked)
    }
    
    func testToggleLike_MultipleTimes() async throws {
        // Given
        let storyId = "story_1"
        
        // When - Toggle 3 times
        try await mockRepository.toggleLike(storyId: storyId)
        try await mockRepository.toggleLike(storyId: storyId)
        try await mockRepository.toggleLike(storyId: storyId)
        
        // Then - should be liked (false -> true -> false -> true)
        let state = await mockRepository.getStoryState(storyId: storyId)
        XCTAssertTrue(state.isLiked)
    }
}
