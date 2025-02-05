//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/4/25.
//

import Combine
import SwiftUI

class AsyncPublisherDataManager {

    @Published var myData: [String] = []

    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Fig")
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {

    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    init() {
        addSubscribers()
    }
    private func addSubscribers() {
        Task {
//            await MainActor.run(body: {
//                self.dataArray = ["One"]
//            })
            
            for await value in manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
            
//            await MainActor.run(body: {
//                self.dataArray = ["Two"]
//            })
        }
    }

    func start() async {
        await manager.addData()
    }

}

struct AsyncPublisherBootcamp: View {

    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)

                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
