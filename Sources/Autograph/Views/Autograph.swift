//
//  Autograph.swift
//
//
//  Created by jensmoes on 10/18/23.
//

import SwiftUI
import SwiftUIHelpers

public struct Autograph: View {

    /// Initializer for the Autograph view.
    /// - Parameter data: Provide the binding to the destination of the user input data (the autograph)
    /// - Parameter canvasSize: If provided this will contain the size of the drawing canvas at any given time during the views lifecycle. Use this to capture the aspect ratio for any future reproduction of the data.
    /// - Parameter isActive: If provided this will provide the user activity state of the view. It will be true while input is being actively recorded.
    /// - Parameter strokeWidth: The displayed with of the strokes. Defaults to 2.0
    /// - Parameter strokeColor: The color of the strokes. Defaults to black.
    public init(_ data: Binding<[[CGPoint]]>,
                canvasSize: Binding<CGSize>? = nil,
                isActive: Binding<Bool>? = nil,
                strokeWidth: CGFloat = 2.0,
                strokeColor: Color = .black) {
        self.data = data
        self.canvasSize = canvasSize
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        // Initialize with provided data
        self.viewModel = AutographViewModel(data: self.data)
    }
    
    /// The data representing the autograph in normalized form
    var data: Binding<[[CGPoint]]>
    /// Binding to the canvas size
    var canvasSize: Binding<CGSize>?
    /// A binding to a boolean indicating drawing is in progress
    var isActive: Binding<Bool>?

    private var viewModel: AutographViewModel

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
                        viewModel.addPoint(value.location, from: canvas.size, isFirst: true)
                    } else {
                        viewModel.addPoint(value.location, from: canvas.size, isFirst: value.location == value.startLocation)
                    }
                    // We are inside the bounds
                    isOutOfBounds = false
                } else {
                    // We are out of bounds
                    isOutOfBounds = true
                    // Treat this like the end of a stroke
                    viewModel.endStroke()
                }
            }).onEnded({ value in
                isActive?.wrappedValue = false
                // Handle end of gesture
                viewModel.endStroke()
            })
        )
        .geometry(frame: $canvas, in: .local)
        .onChange(of: canvas, perform: { newValue in
            // Map the canvas to external binding if provided
            canvasSize?.wrappedValue = newValue.size
        })
    }
    


}

/// A [``Shape``](https://developer.apple.com/documentation/swiftui/shape) representing the autograph from captured data
public struct AutographShape: Shape {
    
    /// - Parameter data: The strokes data to render
    public init(data: [[CGPoint]]) {
        self.data = data
    }
    
    /// The strokes
    let data: [[CGPoint]]
    
    /// Created a [``Path``](https://developer.apple.com/documentation/swiftui/path) of the shape.
    /// - Parameter rect: The [``CGRect``](9https://developer.apple.com/documentation/corefoundation/cgrect) for the path.
    public func path(in rect: CGRect) -> Path {
        return data.path(in: rect.size)
    }
    
    
}

#Preview {
    Autograph(.constant([]))
}
