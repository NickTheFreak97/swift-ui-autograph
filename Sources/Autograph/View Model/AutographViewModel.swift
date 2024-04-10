//
//  AutographViewModel.swift
//  
//
//  Created by Jens Troest on 10/4/24.
//

import Foundation
import SwiftUI

/// The ViewModel for the Autograph view
struct AutographViewModel {
    var data: Binding<[[CGPoint]]>
    func addPoint(_ point: CGPoint, from canvas: CGSize, isFirst: Bool = false) {
        print("isFirst => \(isFirst)")
        let transform = CGAffineTransform(scaleX: 1 / canvas.width, y: 1 / canvas.height)
        let normalized = point.applying(transform)
        // If there is no data yet initialize with the first tentative stroke with one point in it
        if data.isEmpty {
            data.wrappedValue.append([normalized]) // First point
            return
        }
        
        // Find the last stroke
        let lastIndex = data.wrappedValue.index(before: data.endIndex)
        if isFirst {
            if data.wrappedValue[lastIndex].count < 2 {
                // Replace any single point strokes
                data.wrappedValue[lastIndex] = [normalized]
                print("Recycling last stroke (invalid)")
            } else {
                // Otherwise add a new stroke
                data.wrappedValue.append([normalized])
                print("Adding a new stroke")
            }
        } else {
            // Add to the last stroke
            data.wrappedValue[lastIndex].append(normalized)
            print("Adding point to stroke \(lastIndex)")
        }
    }
    
    /// Clean up activities after a stroke ends
    /// This removes the last stroke if it contains 1 or zero points
    func endStroke() {
        let lastIndex = data.wrappedValue.index(before: data.endIndex)

        if let last = data.wrappedValue.last {
            if last.count < 2 {
                print("Removing last stroke (\(lastIndex)) with \(last.count) points")
                data.wrappedValue.remove(at: lastIndex)
            }
        }
        
    }
}
