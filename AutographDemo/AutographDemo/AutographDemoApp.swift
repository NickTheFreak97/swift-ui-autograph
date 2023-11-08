//
//  AutographDemoApp.swift
//  AutographDemo
//
//  Created by jensmoes on 10/19/23.
//

import SwiftUI
import Autograph
import Combine
@main
struct AutographDemoApp: App {
    
    @StateObject private var myAppDataModel = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myAppDataModel)
        }
    }
    
}

// Example app model
class AppData: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    internal init() {
        
        // Listening to changes in activity
        autographData.$isActive
            .sink{ value in
                print("isActive is \(value)")
            }
            .store(in: &cancellables)
        
        // Listening to changes in content
        autographData.$isEmpty
            .sink { value in
                print("isEmpty is \(value)")
            }
            .store(in: &cancellables)
        
        // Handles the nested ObservableObject problem
        autographData.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
        
    }

    static let sampleData: [[CGPoint]] = [
        [CGPoint(x: 0.5, y: 0.5),
        CGPoint(x: 0.75, y: 0.75)]
    ]
    // Pre load with sample data example
//    @Published var autographData = AutoGraphData(sampleData)
    // Empty slate example
    @Published var autographData = AutoGraphData()
}
