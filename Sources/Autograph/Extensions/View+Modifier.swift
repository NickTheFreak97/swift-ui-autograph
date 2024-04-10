//
//  View+Modifier.swift
//  
//
//  Created by Jens Troest on 10/4/24.
//

import Foundation
import SwiftUI

extension View {
    /// Adds a view under the created strokes.
    /// - Parameter under: The view to display underneath the strokes. For example a dotted signature line, or a background.
    public func underlay<U: View>(@ViewBuilder under: @escaping () -> U) -> some View {
        ZStack {
            under()
            self
        }
    }

}
