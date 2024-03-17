//
//  PreviewContainer.swift
//  AutographDemo
//
//  Created by Jens Troest on 3/13/24.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: AutoGraphCard.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<AutoGraphCard>()).isEmpty {
            Samples.sampleAutographCards.forEach { container.mainContext.insert($0) }
        }
        return container
    } catch {
        fatalError("Failed to create preview container")
    }
}()
