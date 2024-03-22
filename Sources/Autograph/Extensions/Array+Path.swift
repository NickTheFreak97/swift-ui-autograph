//
//
//  Array+Path.swift
//
//
//  Created by jensmoes on 11/8/23.
//


import Foundation
import SwiftUI

public extension Array where Element == [CGPoint] {
    // MARK: Shape
    
    /// Returns the [``Path``](https://developer.apple.com/documentation/swiftui/path) represented by the array
    /// - Parameter canvas: The size of the canvas to scale to
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
    
    // MARK: SVG
    private var svgFooter: String {
        "</svg>\n"
    }
    
    private var pathHeader: String {
        "<path d=\""
    }
    
    private var pathFooter: String {
        "\"/>\n"
    }
    
    private func move(to: CGPoint) -> String {
        "M\(to.x) \(to.y) "
    }
    
    private func addLine(to: CGPoint) -> String {
        "L\(to.x) \(to.y) "
    }
    
    /**
     Generates a string representation of the path as SVG
     - Parameters:
        - strokeWidth: The width of the stroke
        - strokeColor: The color to use for the stroke in the SVG
        - canvas:The size of the canvas on which to render the path
     - Returns: The string representation of the path in SVG format or `nil` if no strokes exists
     */
    func svg(strokeWidth: CGFloat = 2,
             strokeColor: String = "black",
             on canvas: CGSize) -> String? {
        
        if isEmpty {return nil}
        
        let xmlHeader = """
<?xml version=\"1.0" encoding="UTF-8" standalone="no"?>

"""
        // SVG header with provided data
        let svgHeader = """
        <svg xmlns="http://www.w3.org/2000/svg" width="\(canvas.width)" height="\(canvas.height)" fill="none" stroke="\(strokeColor)" stroke-width="\(strokeWidth)">
        
        """
        
        // Point transform from normalized form
        let transform = CGAffineTransform(scaleX: canvas.width, y: canvas.height)
        
        // String representation of the signature in SVG format
        var svg = xmlHeader + svgHeader // Add the SVG headers
        
        forEach { stroke in
            if stroke.isEmpty {return} // Ignore empty
            var path = pathHeader + move(to: stroke.first!.applying(transform)) // Force unwrap OK
            // Add lines between the remaining points in the stroke
            for p in stroke[1...] {
                path += addLine(to: p.applying(transform))
            }
            // Add the path footer
            path += pathFooter
            // Add path to the svg
            svg += path
        }
        // End the svg
        svg += svgFooter
        return svg
    }


}
