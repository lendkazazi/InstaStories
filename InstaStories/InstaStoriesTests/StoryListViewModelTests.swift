//
//  StoryListViewModelTests.swift
//  InstaStoriesTests
//
//  Created by Lend Kazazi on 12/10/25.
//
import XCTest
@testable import InstaStories

@MainActor
final class StoryListViewModelTests: XCTestCase {
    var sut: StoryListViewModel!
    var mockRepository: MockStoryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockStoryRepository()
        sut = StoryListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Initial Load Tests
    
    func testLoadInitialStories_Success() async {
        // Given
        let mockStories = MockStoryRepository.makeMockStories(count: 20)
        mockRepository.fetchStoriesResult = .success(mockStories)
        
        // When
        await sut.loadInitialStories()
        
        // Then
        XCTAssertEqual(sut.storiesWithState.count, 20)
        XCTAssertTrue(mockRepository.fetchStoriesCalled)
        XCTAssertEqual(mockRepository.lastFetchedPage, 1)
        XCTAssertEqual(mockRepository.lastFetchedLimit, 20)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testLoadInitialStories_Failure() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        await sut.loadInitialStories()
        
        // Then
        XCTAssertEqual(sut.storiesWithState.count, 0)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadInitialStories_DoesNotLoadWhenAlreadyLoading() async {
        // Given
        let mockStories = MockStoryRepository.makeMockStories(count: 10)
        mockRepository.fetchStoriesResult = .success(mockStories)
        
        // When - start two loads simultaneously
        async let load1: () = sut.loadInitialStories()
        async let load2: () = sut.loadInitialStories()
        
        await load1
        await load2
        
        // Then - should only load once
        XCTAssertEqual(sut.storiesWithState.count, 10)
    }
    
    // MARK: - Pagination Tests
    
    func testLoadMoreStories_WhenApproachingEnd() async {
        // Given
        let initialStories = MockStoryRepository.makeMockStories(count: 20)
        mockRepository.fetchStoriesResult = .success(initialStories)
        await sut.loadInitialStories()
        
        // Prepare next page
        let nextPageStories = MockStoryRepository.makeMockStories(count: 20)
        mockRepository.fetchStoriesResult = .success(nextPageStories)
        
        // When - trigger pagination at 16th story (5 from end)
        let sixteenthStory = sut.storiesWithState[15]
        await sut.loadMoreStoriesIfNeeded(currentStory: sixteenthStory)
        
        // Give it a moment to load
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockRepository.lastFetchedPage, 2)
        XCTAssertTrue(sut.storiesWithState.count >= 20) // At least initial stories
    }
    
    func testLoadMoreStories_DoesNotLoadWhenNotNearEnd() async {
        // Given
        let mockStories = MockStoryRepository.makeMockStories(count: 20)
        mockRepository.fetchStoriesResult = .success(mockStories)
        await sut.loadInitialStories()
        
        // Reset the call tracker
        mockRepository.fetchStoriesCalled = false
        
        // When - trigger at first story (not near end)
        let firstStory = sut.storiesWithState[0]
        await sut.loadMoreStoriesIfNeeded(currentStory: firstStory)
        
        // Then - should not trigger another fetch
        XCTAssertFalse(mockRepository.fetchStoriesCalled)
    }
    
    // MARK: - Story State Tests
    
    func testUpdateStoryState() async {
        // Given
        let mockStories = MockStoryRepository.makeMockStories(count: 5)
        mockRepository.fetchStoriesResult = .success(mockStories)
        await sut.loadInitialStories()
        
        let storyId = mockStories[0].id
        mockRepository.storyStates[storyId] = StoryState(
            storyId: storyId,
            isSeen: true,
            isLiked: true
        )
        
        // When
        await sut.updateStoryState(storyId: storyId)
        
        // Then
        XCTAssertTrue(sut.storiesWithState[0].isSeen)
        XCTAssertTrue(sut.storiesWithState[0].isLiked)
    }
    
    func testRefreshStates() async {
        // Given
        let mockStories = MockStoryRepository.makeMockStories(count: 3)
        mockRepository.fetchStoriesResult = .success(mockStories)
        await sut.loadInitialStories()
        
        // Mark all as seen and liked
        for story in mockStories {
            mockRepository.storyStates[story.id] = StoryState(
                storyId: story.id,
                isSeen: true,
                isLiked: true
            )
        }
        
        // When
        await sut.refreshStates()
        
        // Then
        XCTAssertTrue(sut.storiesWithState.allSatisfy { $0.isSeen })
        XCTAssertTrue(sut.storiesWithState.allSatisfy { $0.isLiked })
    }
}
