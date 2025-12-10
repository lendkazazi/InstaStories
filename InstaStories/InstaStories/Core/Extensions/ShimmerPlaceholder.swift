//
//  ShimmerPlaceholder.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import SwiftUI

struct ShimmerPlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .shimmer()
    }
}
