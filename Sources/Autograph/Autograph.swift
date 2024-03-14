//
//  Autograph.swift
//
//
//  Created by jensmoes on 10/18/23.
//

import SwiftUI
import SwiftUIHelpers

public struct Autograph: View {

    public init(_ data: Binding<[[CGPoint]]>,
                canvasSize: Binding<CGRect>? = nil,
                isActive: Binding<Bool>? = nil,
                strokeWidth: CGFloat = 2.0,
                strokeColor: Color = .black) {
        self.data = data
        self.canvasSize = canvasSize
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
    
    /// Adds a view under the created strokes.
    public func underlay<U: View>(@ViewBuilder under: @escaping () -> U) -> some View {
        ZStack {
            under()
            self
        }
    }
    /// The data representing the autograph in normalized form
    var data: Binding<[[CGPoint]]>
    /// Binding to the canvas size
    var canvasSize: Binding<CGRect>?
    /// A binding to a boolean indicating drawing is in progress
    var isActive: Binding<Bool>?

    /// The drawing canvas dimensions
    @State private var canvas: CGRect = .zero
    /// Tracks whether the gesture is outside the view
    /// Used to identify the cases where the gesture returns back in bounds
    @State
    private var isOutOfBounds: Bool = false
        
    let strokeWidth: CGFloat!
    let strokeColor : Color!

    public var body: some View {
        ZStack {
            // The gesture handler
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(Rectangle())

            // Drawing the input
            AutographShape(data: data.wrappedValue)
                .stroke(lineWidth: strokeWidth)
                .foregroundStyle(strokeColor)
        }
        .highPriorityGesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                isActive?.wrappedValue = true
                // Record gesture data.
                if (canvas.contains(value.startLocation) && canvas.contains(value.location)) {
                    // Both start and current are within the bounds
                    if isOutOfBounds {
                        // Case of returning from outside bounds.
                        // Insert a new stroke
                        addPoint(value.location, from: canvas.size, isFirst: true)
                    } else {
                        addPoint(value.location, from: canvas.size, isFirst: value.location == value.startLocation)
                    }
                    // We are inside the bounds
                    isOutOfBounds = false
                } else {
                    // We are out of bounds
                    isOutOfBounds = true
                    // Treat this like the end of a stroke
                    endStroke()
                }
            }).onEnded({ value in
                isActive?.wrappedValue = false
                // Handle end of gesture
                endStroke()
            })
        )
        .geometry(frame: $canvas, in: .local)
        .onChange(of: canvas, perform: { newValue in
            // Map the canvas to external binding if provided
            canvasSize?.wrappedValue = newValue
        })
    }
    
    fileprivate func addPoint(_ point: CGPoint, from canvas: CGSize, isFirst: Bool = false) {
        print("isFirst => \(isFirst)")
        let transform = CGAffineTransform(scaleX: 1 / canvas.width, y: 1 / canvas.height)
        let normalized = point.applying(transform)
        // FIXME: See if we can do without this additional state
//        if data.count == currentStroke {
//            // New stroke add a new array
//            data.wrappedValue.append([normalized])
//        } else {
//            data.wrappedValue[currentStroke].append(normalized)
//        }
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
    fileprivate func endStroke() {
//        currentStroke = currentStroke + 1
        let lastIndex = data.wrappedValue.index(before: data.endIndex)

        if let last = data.wrappedValue.last {
            if last.count < 2 {
                print("Removing last stroke (\(lastIndex)) with \(last.count) points")
                data.wrappedValue.remove(at: lastIndex)
            }
        }
        
    }


}


public struct AutographShape: Shape {
    public init(data: [[CGPoint]]) {
        self.data = data
    }
    
    /// The strokes
    let data: [[CGPoint]]
    
    public func path(in rect: CGRect) -> Path {
        return data.path(in: rect.size)
    }
    
    
}


//#Preview {
//    Autograph(data: AutoGraphData())
//}
