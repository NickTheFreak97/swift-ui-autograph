//
//  AutographCardView.swift
//  AutographDemo
//
//  Created by Jens Troest on 3/11/24.
//

import SwiftUI
import Autograph

struct AutographCardView: View {
    @State var card: AutoGraphCard
    
    @State private var isEditingName = false
    var body: some View {
        HStack {
            if isEditingName {
                TextField("Enter a name", text: card.nameBinding)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(SubmitLabel.done)
                    .padding(20)
            } else {
                Text(card.name ?? "No name")
            }
            
            Button {
                withAnimation {
                    isEditingName.toggle()
                }
                
            } label: {
                Image(systemName: isEditingName ? "square.and.arrow.down.fill": "pencil") //xmark.circle.fill   
                    .foregroundColor(.primary)
            }
            
        }
        .font(.largeTitle)
        
        AutographShape(data: card.signature)
            .stroke(lineWidth: 1.0)
            .foregroundColor(.black)
            .aspectRatio(2.0, contentMode: .fit)
            .padding()
            
    }
    
}

#Preview {
    MainActor.assumeIsolated {
        let container = previewContainer
        
        return AutographCardView(card: Samples.sampleAutographCards.first!)
            .modelContainer(container)
    }
}
