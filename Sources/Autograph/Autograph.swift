//
//  Autograph.swift
//
//
//  Created by jensmoes on 10/18/23.
//

import SwiftUI
import SwiftUIHelpers

public struct Autograph<T: Autographic>: View {

    public init(data: T, strokeWidth: CGFloat = 2.0, strokeColor: Color = .black) {
        self.model = data
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }
    
    /// Adds a ``View`` under the created strokes.
    public func underlay<U: View>(@ViewBuilder under: @escaping () -> U) -> some View {
        ZStack {
            under()
            self
        }
    }
    
    @ObservedObject
    private var model: T
    
    /// The drawing canvas
    @State
    private var canvas: CGRect = .zero
    
    /// Tracks whether the gesture is outside the view
    /// Used to identify the cases where the gesture returns back in bounds
    @State
    private var isOutOfBounds: Bool = false
    
    var strokeWidth: CGFloat = 2.0
    var strokeColor = Color.blue

    public var body: some View {
        ZStack {
            // The gesture handler
            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())

            // Drawing the input
            PennedShape(data: model.normalized)
                .stroke(lineWidth: strokeWidth)
                .foregroundColor(strokeColor)
        }
        .highPriorityGesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                model.isActive = true
                // Record gesture data.
                if (canvas.contains(value.startLocation) && canvas.contains(value.location)) {
                    // Both start and current are within the bounds
                    if isOutOfBounds {
                        // Case of returning from outside bounds.
                        // Insert a break as the last point is the one before leaving
                        model.addBreak()
                    } else {
                        model.addPoint(value.location, from: canvas.size)
                    }
                    // We are inside the bounds
                    isOutOfBounds = false
                } else {
                  // We are out of bounds
                    isOutOfBounds = true
                }
            }).onEnded({ value in
                model.isActive = false
                // Handle end of gesture by adding a break
                model.addBreak()
            })
        )
        .geometry(frame: $canvas, in: .local)
        .onChange(of: canvas, perform: { newValue in
            model.canvasSize = canvas.size
        })
    }
    


}

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

fileprivate struct PennedShape: Shape {
    /// The strokes
    let data: [[CGPoint]]
    
    func path(in rect: CGRect) -> Path {
        return data.path(in: rect.size)
    }
    
    
}


#Preview {
    Autograph(data: AutoGraphData())
}
