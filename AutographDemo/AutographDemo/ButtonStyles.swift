//
//  ButtonStyles.swift
//  AutographDemo
//
//  Created by Jens Troest on 3/13/24.
//

import SwiftUI

/// A styled button shaped as a capsule that grows to fit its parent view and is filled with a solid color
struct FilledCapsuleButtonStyle: ButtonStyle {
    internal init(fillColor: Color = .clear) {
        self.fillColor = fillColor
    }
    
    let fillColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding([.top, .bottom], 13)
            .padding([.leading, .trailing], 12) // Just to make sure the text don't droop over the radius ears
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
            .background(
                Capsule()
                    .fill(fillColor)
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .shadow(color: fillColor.opacity(0.2), radius: 10, x: 0.5, y: 0.5)
    }
}

/// A button style that is clear with a border ``AutoGraph/SwiftUI/Array``
struct ClearCapsuleButtonStyle: ButtonStyle {

    let border: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding([.top, .bottom], 13)
            .padding([.leading, .trailing], 12) // Just to make sure the text don't droop over the radius ears
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
            .overlay(
                Capsule()
                        .stroke(border, lineWidth: 1.0)
            )
            .contentShape(
                // We still need the fill in order to expand the touch area to the whole button
                Capsule()
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}


#Preview {
    Button(action: {}) {
        Text("Benjamin Button")
    }
    .buttonStyle(FilledCapsuleButtonStyle(fillColor: .gray))
}
