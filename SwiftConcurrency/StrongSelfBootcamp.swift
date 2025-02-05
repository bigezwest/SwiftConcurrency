//
//  StrongSelfBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/5/25.
//

import SwiftUI

final class StrongSelfDataService {
    func getData() async -> String {
        "Updated Data"
    }
}

final class StrongSelfBootcampViewModel: ObservableObject {
    @Published var data: String = "Some Title!"
    let dataServcie = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach( {$0.cancel() })
        myTasks = []
    }
    
    // This implies a strong reference
    func updateData() {
        Task {
            data = await dataServcie.getData()
        }
    }
    // This is a strong reference (self is for clarity, but implied)
    func updateData2(data: String) {
        Task {
            self.data = await self.dataServcie.getData()
        }
    }
    // This is a strong reference
    func updateData3() {
        Task  { [self] in
            self.data = await self.dataServcie.getData()
        }
    }
    // This implies a weak reference (
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataServcie.getData() {
                self?.data = data
            }
        }
    }
    // We don't need to manage weak strong, we can manage the task
    func updateData5() {
        someTask = Task {
            self.data = await self.dataServcie.getData()
        }
    }
    // We can manage the task
    func updateData6() {
        let task1 = Task {
            self.data = await self.dataServcie.getData()
        }
        myTasks.append(task1)
        let task2 = Task {
            self.data = await self.dataServcie.getData()
        }
        myTasks.append(task2)
    }
    // We purposely do not cancel tasks to keep strong references
    func updateData7() {
        Task {
            self.data = await self.dataServcie.getData()
        }
        Task.detached {
            self.data = await self.dataServcie.getData()
        }
    }
}

struct StrongSelfBootcamp: View {
    
    @StateObject private var viewModel = StrongSelfBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
    }
}

#Preview {
    StrongSelfBootcamp()
}
