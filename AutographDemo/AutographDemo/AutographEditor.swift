//
//  AutographEditor.swift
//  AutographDemo
//
//  Created by Jens Troest on 3/11/24.
//

import SwiftUI
import Autograph

struct AutographEditor: View {
    @State var card : AutoGraphCard = AutoGraphCard()
    @State private var canvas: CGRect = .zero
    @State private var boxSize: CGSize = .zero
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass

    /// Used to optimize writing space in landscape mode
    private var verticalSpacing: Double {
        if verticalSizeClass == .regular {
            return 20
        }
        return 0
    }
    
    private var isPortrait: Bool {
        verticalSizeClass == .regular
    }
    var body: some View {
        VStack(spacing: verticalSpacing) {
                        
            if isPortrait {
                TextField("Name your idol", text: Binding(
                    get: { self.card.name ?? "" },
                    set: { self.card.name = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 10)
            }
            
            RoundedRectangle(cornerRadius: 6.0)
                .stroke(Color.gray, lineWidth: 1)
                .overlay {
                    Autograph($card.signature, canvasSize: $canvas, strokeWidth: 2.0 , strokeColor: Color.black)
                        .underlay {
                            // Add a signature line
                            VStack {
                                Spacer()
                                
                                Rectangle()
                                    .frame(height: 3)
                                    .foregroundStyle(Color.secondary)
                                    .padding(20)
                            }
                            
                        }
                        .overlay(alignment: .topLeading) {
                            Group {
                                if !card.isEmpty {
                                    Button("Clear") {
                                        card.signature.removeAll()
                                    }
                                    .foregroundStyle(Color.accentColor)
                                }
                            }
                            .alignmentGuide(.leading) { d in
                                d[.leading] - 20
                            }
                            .alignmentGuide(.top) { d in
                                d[.top] - 10
                            }
                        }
                    //
                    // It is highly recommended to use a fixed aspect ratio if the view changes size (portrait/landscape for example)
                    // in order to maintain the autographs appearance.
                        .frame(height: boxSize.height)
                }
                .aspectRatio(2.0, contentMode: .fit)
                .geometry(size: $boxSize)

            HStack {
                Image(systemName: isPortrait ? "rectangle.landscape.rotate" : "rectangle.portrait.rotate")
                Text(isPortrait ? "Rotate device for larger view" : "Rotate device to finish")
                    .fontWeight(.light)
            }
            .offset(y: isPortrait ? 0 : 10)
            .padding(verticalSpacing)
        }
        .padding(.horizontal, isPortrait ? 20 : 2)
        .padding(.vertical, 0)
        .ignoresSafeArea(.all,edges: [.bottom])
        .background(Color.white)
        .navigationBarBackButtonHidden(!isPortrait)

        if isPortrait {
            Button("Save") {
                // Example of data capture.
                modelContext.insert(card)
                print("\(card.signature.count) strokes were made on canvas \(canvas.size):")
                print("SVG output is: \n\(card.signature.svg(on: canvas.size) ?? "nil")")
                dismiss()
            }
            .if( card.name?.isEmpty ?? true || card.signature.isEmpty ) { button in
                button.buttonStyle(FilledCapsuleButtonStyle(fillColor: Color.gray.opacity(0.2)))
                    .disabled(true)
                    .eraseToAnyView()
            } else: { button in
                button.buttonStyle(ClearCapsuleButtonStyle(border: .primary))
                    .animation(.linear(duration: 1.0), value: card.name)
                    .eraseToAnyView()
            }
            .frame(maxHeight: 30)
            .padding()
        }
        
        Spacer()
    }

}

#Preview {
    MainActor.assumeIsolated {
        // Ensure the container is instantiated
        let _ = previewContainer
        return AutographEditor()
            .modelContainer(previewContainer)
        
    }
}
