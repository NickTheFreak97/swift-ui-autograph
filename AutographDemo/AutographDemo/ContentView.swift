//
//  ContentView.swift
//  AutographDemo
//
//  Created by jensmoes on 10/19/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query(sort: \AutoGraphCard.creationDate, order: .reverse) private var autographs: [AutoGraphCard]
    @State private var canvas: CGRect = .zero
    @State private var path: [AutoGraphCard] = []
    @State private var editing = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                ForEach(autographs){ autograph in
                    NavigationLink(autograph.name ?? "Unknown", value: autograph)
                        .navigationDestination(for: AutoGraphCard.self) { autograph in
                            AutographCardView(card: autograph)
                        }
                }
                .onDelete { set in
                    for index in set {
                        modelContext.delete(autographs[index])
                    }
                }
                
            }
            .navigationBarTitle("Autograph Collector", displayMode: .inline)
            .navigationBarItems(trailing: 
                    Button {
                        editing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                .navigationDestination(isPresented: $editing, destination: {
                    AutographEditor()
                })
                
            )
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}

