//
//  DesignSystem.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation

import SwiftUI

enum DesignSystem {
    
    enum Colors {
        // Primary Colors
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let accent = Color.accentColor
        
        // Semantic Colors
        static let background = Color(uiColor: .systemBackground)
        static let surface = Color(uiColor: .secondarySystemBackground)
        static let error = Color.red
        static let success = Color.green
        
        // Text Colors
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color(.tertiaryLabel)
        static let textInverse = Color.white
        
        // Story Specific
        static let storyGradientStart = Color.purple
        static let storyGradientMiddle = Color.pink
        static let storyGradientEnd = Color.orange
        static let storySeenBorder = Color.gray.opacity(0.3)
        static let likeRed = Color.red
        
        // Overlay Colors
        static let overlayDark = Color.black.opacity(0.6)
        static let overlayLight = Color.black.opacity(0.3)
        static let shimmerBase = Color.gray.opacity(0.2)
        static let shimmerHighlight = Color.white.opacity(0.3)
    }
    
    // MARK: - Typography
    enum Typography {
        // Font Sizes
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption1: CGFloat = 12
        static let caption2: CGFloat = 11
        
        // Predefined Text Styles
        static func largeTitle(weight: Font.Weight = .bold) -> Font {
            .system(size: largeTitle, weight: weight)
        }
        
        static func title1(weight: Font.Weight = .bold) -> Font {
            .system(size: title1, weight: weight)
        }
        
        static func title2(weight: Font.Weight = .bold) -> Font {
            .system(size: title2, weight: weight)
        }
        
        static func headline(weight: Font.Weight = .semibold) -> Font {
            .system(size: headline, weight: weight)
        }
        
        static func body(weight: Font.Weight = .regular) -> Font {
            .system(size: body, weight: weight)
        }
        
        static func subheadline(weight: Font.Weight = .regular) -> Font {
            .system(size: subheadline, weight: weight)
        }
        
        static func caption(weight: Font.Weight = .regular) -> Font {
            .system(size: caption1, weight: weight)
        }
        
        static func footnote(weight: Font.Weight = .regular) -> Font {
            .system(size: footnote, weight: weight)
        }
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 40
        static let xxxl: CGFloat = 48
    }
    
    // MARK: - Layout
    enum Layout {
        static let storyItemSize: CGFloat = 72
        static let storyBorderWidth: CGFloat = 3
        static let progressBarHeight: CGFloat = 2
        static let iconSize: CGFloat = 24
        static let profileImageSmall: CGFloat = 32
        static let profileImageMedium: CGFloat = 64
        static let profileImageLarge: CGFloat = 80
    }
}
