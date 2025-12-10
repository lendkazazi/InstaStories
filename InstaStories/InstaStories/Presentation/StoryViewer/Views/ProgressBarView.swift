//
//  ProgressBarView.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    let isCurrent: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .cornerRadius(1)
        .animation(isCurrent ? .linear(duration: 0.1) : .none, value: progress)
    }
}
