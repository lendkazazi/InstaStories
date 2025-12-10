//
//  View+Extension.swift
//  InstaStories
//
//  Created by Lend Kazazi on 12/10/25.
//

import Foundation
import SwiftUI

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
    
    func designSystemFont(_ style: Font) -> some View {
        self.font(style)
    }
}
