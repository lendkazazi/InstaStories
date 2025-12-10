//
//  StoryListItemView.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import SwiftUI

struct StoryListItemView: View {
    let storyWithState: StoryWithState
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            ZStack {
                Circle()
                    .stroke(
                        storyWithState.isSeen ?
                        AnyShapeStyle(DesignSystem.Colors.storySeenBorder) :
                        AnyShapeStyle(LinearGradient(
                            colors: [
                                DesignSystem.Colors.storyGradientStart,
                                DesignSystem.Colors.storyGradientMiddle,
                                DesignSystem.Colors.storyGradientEnd
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )),
                        lineWidth: DesignSystem.Layout.storyBorderWidth
                    )
                    .frame(
                        width: DesignSystem.Layout.storyItemSize,
                        height: DesignSystem.Layout.storyItemSize
                    )
                
                AsyncImage(url: URL(string: storyWithState.story.user.profileImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ShimmerPlaceholder()
                }
                .frame(
                    width: DesignSystem.Layout.profileImageMedium,
                    height: DesignSystem.Layout.profileImageMedium
                )
                .clipShape(Circle())
            }
            
            Text(storyWithState.story.user.username)
                .font(DesignSystem.Typography.caption())
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)
                .frame(width: 80)
        }
    }
}

