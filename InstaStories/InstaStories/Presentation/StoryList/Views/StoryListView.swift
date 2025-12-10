//
//  StoryListView.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import SwiftUI

struct StoryListView: View {
    @StateObject private var viewModel: StoryListViewModel
    @State private var selectedStory: StoryWithState?
    
    init(repository: StoryRepository) {
        _viewModel = StateObject(wrappedValue: StoryListViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    storiesSection
                    
                    Divider()
                    
                    feedPostsSection
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("InstaStories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "heart")
                        .font(.system(size: DesignSystem.Layout.iconSize - 6))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "paperplane")
                        .font(.system(size: DesignSystem.Layout.iconSize - 6))
                }
            }
            .task {
                if viewModel.storiesWithState.isEmpty {
                    await viewModel.loadInitialStories()
                }
            }
            .fullScreenCover(item: $selectedStory) { story in
                StoryViewerView(
                    initialStory: story,
                    allStories: viewModel.storiesWithState,
                    repository: viewModel.repository,
                    onDismiss: {
                        selectedStory = nil
                        Task {
                            await viewModel.refreshStates()
                        }
                    }
                )
            }
        }
        
        if let error = viewModel.errorMessage {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .padding()
        }
    }
    
    // MARK: - Stories Section
    private var storiesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: DesignSystem.Spacing.md) {
                ForEach(viewModel.storiesWithState) { storyWithState in
                    StoryListItemView(storyWithState: storyWithState)
                        .onTapGesture {
                            selectedStory = storyWithState
                        }
                        .onAppear {
                            Task {
                                await viewModel.loadMoreStoriesIfNeeded(currentStory: storyWithState)
                            }
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: 80, height: 100)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
        .frame(height: 120)
    }
    
    // MARK: - Feed Posts Section
    private var feedPostsSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { index in
                FeedPostShimmerView()
            }
        }
    }
}

