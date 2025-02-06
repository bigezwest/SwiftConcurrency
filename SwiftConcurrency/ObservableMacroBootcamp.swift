//
//  ObservableMacroBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/6/25.
//

import SwiftUI

actor TitleDatabase {
    func getNewTitle() -> String {
        "Some New Title "
    }
}


@Observable class ObservableMacroViewModel {
    
    @ObservationIgnored let database = TitleDatabase()
    @MainActor var title: String = "Starting Title"
    
    func updateTitle() {
        Task { @MainActor in
            title = await database.getNewTitle()
            print(Thread.current)
        }
    }
}


struct ObservableMacroBootcamp: View {
    
    @State private var viewModel = ObservableMacroViewModel()
    
    var body: some View {
        Text(viewModel.title)
            .onAppear {
                viewModel.updateTitle()
            }
    }
}

#Preview {
    ObservableMacroBootcamp()
}
