//
//  StoryViewerView.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import SwiftUI

struct StoryViewerView: View {
    @StateObject private var viewModel: StoryViewerViewModel
    @GestureState private var isLongPressing = false
    @State private var dragOffset: CGFloat = 0
    
    let onDismiss: () -> Void
    
    init(
        initialStory: StoryWithState,
        allStories: [StoryWithState],
        repository: StoryRepository,
        onDismiss: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: StoryViewerViewModel(
                initialStory: initialStory,
                allStories: allStories,
                repository: repository
            )
        )
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                AsyncImage(url: URL(string: viewModel.currentStory.story.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        GeometryReader { geo in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        }
                    default:
                        Color.clear
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .offset(x: dragOffset)
                .animation(.spring(response: 0.3), value: dragOffset)
                
                VStack {
                    LinearGradient(
                        colors: [DesignSystem.Colors.overlayDark, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 200)
                    
                    Spacer()
                    
                    LinearGradient(
                        colors: [.clear, DesignSystem.Colors.overlayLight],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 150)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    topBar.padding(.top, 50)
                    Spacer()
                    bottomBar.padding(.bottom, 40)
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                viewModel.handleTap(at: location, in: geometry.size)
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.2)
                    .updating($isLongPressing) { value, state, _ in
                        state = value
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        dragOffset = value.translation.width * 0.3
                        viewModel.pauseStory()
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 100
                        
                        if value.translation.width > threshold && viewModel.canGoPrevious {
                            viewModel.moveToPrevious()
                        } else if value.translation.width < -threshold && viewModel.canGoNext {
                            viewModel.moveToNext()
                        }
                        
                        dragOffset = 0
                        viewModel.resumeStory()
                    }
            )
            .onChange(of: isLongPressing) { _, isPressing in
                if isPressing {
                    viewModel.pauseStory()
                } else {
                    viewModel.resumeStory()
                }
            }
        }
        .statusBar(hidden: true)
        .onAppear { viewModel.startStory() }
        .onDisappear { viewModel.cleanup() }
    }
    
    @ViewBuilder
    private func storyImageView(for storyWithState: StoryWithState) -> some View {
        AsyncImage(url: URL(string: storyWithState.story.imageURL)) { phase in
            switch phase {
            case .empty:
                Color.clear
            case .success(let image):
                GeometryReader { geo in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            case .failure:
                Color.clear
            @unknown default:
                Color.clear
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        VStack(spacing: 12) {
            // Progress Bars
            HStack(spacing: 4) {
                ForEach(0..<viewModel.totalStories, id: \.self) { index in
                    ProgressBarView(
                        progress: progressForBar(at: index),
                        isCurrent: index == viewModel.currentStoryIndex
                    )
                }
            }
            .frame(height: 2)
            
            // User Info
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: viewModel.currentStory.story.user.profileImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ShimmerPlaceholder()
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                Text(viewModel.currentStory.story.user.username)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(timeAgo(from: viewModel.currentStory.story.timestamp))
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Bottom Bar
    private var bottomBar: some View {
        HStack(spacing: 16) {
            Spacer()
            
            // Like Button
            Button {
                viewModel.toggleLike()
            } label: {
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 28))
                    .foregroundColor(viewModel.isLiked ? .red : .white)
            }
        }
    }
    
    // MARK: - Helpers
    private func progressForBar(at index: Int) -> Double {
        if index < viewModel.currentStoryIndex {
            return 1.0
        } else if index == viewModel.currentStoryIndex {
            return viewModel.progress
        } else {
            return 0.0
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        
        if seconds < 60 {
            return "\(Int(seconds))s"
        } else if seconds < 3600 {
            return "\(Int(seconds / 60))m"
        } else if seconds < 86400 {
            return "\(Int(seconds / 3600))h"
        } else {
            return "\(Int(seconds / 86400))d"
        }
    }
}
