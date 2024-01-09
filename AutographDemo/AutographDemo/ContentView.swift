//
//  ContentView.swift
//  AutographDemo
//
//  Created by jensmoes on 10/19/23.
//

import SwiftUI
import Autograph
struct ContentView: View {
    
    @EnvironmentObject
    var appData: AppData
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Example adding content using under and overlay
            Autograph(data: appData.autographData, strokeColor: .yellow)
                .underlay {
                    // Add a signature line
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(.blue)
                            .padding(20)
                    }
                    
                }
                .overlay(alignment: .topLeading) {
                    Group {
                        if !appData.autographData.isEmpty {
                            Button("Clear") {
                                appData.autographData.clear()
                            }
                        }
                    }
                    .alignmentGuide(.leading) { d in
                        d[.leading] - 20
                    }
                    .alignmentGuide(.top) { d in
                        d[.top] - 10
                    }
                }
                .aspectRatio(2.0, contentMode: .fit)
                .background(.brown)
                .padding()
            
            // Example using ZStack to achieve decorations below the strokes
            VStack {
                ZStack(alignment: .bottom) {
                    // The background color of the box
                    Color.gray.opacity(0.4)
                    
                    // A signature line underneath (z-axis) the pen strokes 20 points from the bottom
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.gray)
                        .alignmentGuide(.bottom, computeValue: { dimension in
                            dimension[.bottom] + 20
                        })
                        .padding()
                    
                    Autograph(data: appData.autographData)
                    //                        .tint(Color.black)
                        .foregroundColor(.teal) // The stroke color
                    
                    if !appData.autographData.isEmpty {
                        Button("Clear") {
                            appData.autographData.clear()
                        }
                    }
                    
                }
                // It is highly recommended to use a fixed aspect ratio if the view changes size (portrait/landscape for example)
                // in order to maintain the autographs appearance.
                .aspectRatio(2.0, contentMode: .fit)
                
                
            }
            .padding()
            .background(Color.white)
            
            Button("Done") {
                // Example of data capture.
                let data = appData.autographData.normalized
                print("\(data.count) strokes were made on canvas \(appData.autographData.canvasSize):")
                print("SVG output is: \n\(appData.autographData.svg ?? "nil")")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

