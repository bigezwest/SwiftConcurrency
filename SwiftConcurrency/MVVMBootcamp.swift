//
//  MVVMBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/5/25.
//

import SwiftUI
final class MyManagerClass {
    func getData() async throws -> String {
        "Some Data"
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some Data"
    }
}
@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "Starting Text"
    private var tasks: [Task<Void, Never>] = []
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
    }
    
    func onCallToActionButtonPresed() {
        Task {
            let task = Task {
                do {
//                    myData = try await managerClass.getData()
                    myData = try await managerActor.getData()
                } catch {
                    print(error)
                }
            }
            tasks.append(task)
        }
    }
}

struct MVVMBootcamp: View {
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPresed()
            }
        }
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVMBootcamp()
}
