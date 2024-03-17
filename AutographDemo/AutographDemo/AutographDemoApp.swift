//
//  AutographDemoApp.swift
//  AutographDemo
//
//  Created by jensmoes on 10/19/23.
//

import SwiftUI

@main
struct AutographDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Color.black)
        }
        .modelContainer(for: AutoGraphCard.self)
    }
    
}
