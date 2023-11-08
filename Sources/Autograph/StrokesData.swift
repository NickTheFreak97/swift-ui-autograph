//
//  StrokesData.swift
//  
//
//  Created by jensmoes on 11/8/23.
//

import Foundation
import SwiftUI

/// Convenience container for data persistence.
/// This can be persisted, encoded for data transfer or transferred across concurrency domains.
public struct StrokesData: Codable, Sendable {
    
    /// Creates an instance of the strokes data container
    /// - Parameter strokes: The points defining all strokes in normalized form. Defaults to an empty list
    /// - Parameter canvasSize: Optional value if you need to preserve the aspect ratio of the data.
    public init(strokes: [[CGPoint]] = [[CGPoint]](), canvasSize: CGSize = .zero) {
        self.strokes = strokes
        self.canvasSize = canvasSize
    }
    
    /// A collection of strokes in normalized form
    var strokes: [[CGPoint]] = [[CGPoint]]()
    /// The size of the canvas that was used for the capture
    var canvasSize: CGSize = .zero
}


extension StrokesData {
    
    /// Renders a ``Path`` representing the current data
    /// - Parameter canvas: The canvas size.
    func path(in canvas: CGSize) -> Path {
        var result = Path()
        // If there are none to return
        if strokes.isEmpty {return result}
        
        let _ = strokes.forEach({ stroke in
            guard let firstPoint = stroke.first else { return }
            // Move to the first point of each stroke
            result.move(to: firstPoint)
            // Insert the rest
            stroke[1...].forEach { point in
                result.addLine(to: point)
            }
        })
        
        let transform = CGAffineTransform(scaleX: canvas.width, y: canvas.height)
        return result.applying(transform)
    }
    
    /// Returns the path in the current canvas size
    var path: Path {
        path(in: canvasSize)
    }

}
