//
//  DataModel.swift
//
//
//  Created by jensmoes on 11/2/23.
//

import Foundation
import SwiftUI

public protocol Autographic: ObservableObject {
    
    /// A boolean value indicating whether a stroke is currently being made.
    /// This is set by the ``Autograph`` view and can be consumed
    /// - Note: This should be implented as a ``Published``.
    /// I have yet to find out how to require that in a protocol
    var isActive: Bool {get set}
    
    /// `false` if the data container contains any points
    /// - Note: This should be implented as a ``Published``.
    /// I have yet to find out how to require that in a protocol
    var isEmpty: Bool {get}

    /// Clears the autograph
    func clear()
    
    // MARK: Output

    /// Strokes in normalized format
    var normalized: [[CGPoint]] {get}
    
    /// Returns the strokes projected onto the provided canvas
    /// Has a default implementation
    func projected(on canvas: CGSize) -> [[CGPoint]]
    
    /// Returns the strokes projected on to the current canvas
    /// Has a default implementation
    var projected : [[CGPoint]] {get}
    
    // MARK: Data Input

    /// Current size of the canvas
    var canvasSize: CGSize {get set}

    /// Signals the end of a stroke to the data container
    func addBreak()
    /// Adds a point to the data container
    func addPoint(_ point: CGPoint, from canvas: CGSize)
    
}

extension Autographic {
    
    /// Returns the strokes projected onto the provided canvas
    public func projected(on canvas: CGSize) -> [[CGPoint]] {
        let transform = CGAffineTransform(scaleX: canvas.width, y: canvas.height)
        return normalized.compactMap { stroke in
            stroke.map { point in
                point.applying(transform)
            }
        }
    }
    /// Returns the strokes projected on to the current canvas
    public var projected : [[CGPoint]] {
        projected(on: canvasSize)
    }
}

public class AutoGraphData: Autographic {
    
    // MARK: Protocol conformance
    
    @Published
    public var isEmpty: Bool = true
        
    @Published
    public var isActive: Bool = false

    public func clear() {
        data.strokes = []
        currentStroke = 0
        isEmpty = true
    }

    public var canvasSize: CGSize {
        get {
            data.canvasSize
        }
        set {
            data.canvasSize = newValue
        }
    }
    
    public var normalized: [[CGPoint]] {
        data.strokes
    }

    public func addPoint(_ point: CGPoint, from canvas: CGSize) {
        let transform = CGAffineTransform(scaleX: 1 / canvas.width, y: 1 / canvas.height)
        let normalized = point.applying(transform)
        if data.strokes.count == currentStroke {
            // New stroke add an empty array
            data.strokes.append([normalized])
        } else {
            data.strokes[currentStroke].append(normalized)
        }
        isEmpty = !data.strokes.contains(where: { element in
            // Ignore all strokes of length 1
            element.count > 1
        })
    }
    /// Adds a break point to the data
    public func addBreak() {
        currentStroke = currentStroke + 1
        
    }

    // MARK: Original code

    /// Internal data backing
    private var data = StrokesData()
    private var currentStroke: Int = 0

    /// Get the current state as SVG
    public var svg: String? {
        return data.svg(on: canvasSize)
    }
    // MARK: Initializers

    /// Creates an instance of the required data model with empty data
    /// - Parameter strokeData: Optional initial value if restoring view from stored data
    public init(_ strokeData: StrokesData = StrokesData(strokes: [])) {
        self.isEmpty = isEmpty
        self.isActive = isActive
        self.data = strokeData
        // Set the current index to current + 1
        self.currentStroke = strokeData.strokes.count
       
    }
    
    /// Creates an instance from an array of strokes
    /// - Parameter strokes: The points defining all strokes in normalized form. Defaults to an empty list
    public convenience init(_ strokes: [[CGPoint]]) {
        self.init(StrokesData(strokes: strokes))
    }
}

