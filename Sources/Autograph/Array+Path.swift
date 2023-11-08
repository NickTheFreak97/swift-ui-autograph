//
//
//  Array+Path.swift
//
//
//  Created by jensmoes on 11/8/23.
//


import Foundation
import SwiftUI
extension Array where Element == [CGPoint] {
    func path(in canvas: CGSize) -> Path {
        var result = Path()
        // If there are none to return
        if isEmpty {return result}
        
        let _ = forEach({ stroke in
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
}
