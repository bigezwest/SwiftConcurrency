//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/2/25.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("Image Returned Successfully")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
                print("Image Returned Successfully")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click Me!") {
                    TaskBootcamp()
                }
            }
        }
    }
}


struct TaskBootcamp: View {
    
    @StateObject var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
        
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }

//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("High: \(Thread()) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .userInitiated) {
//                print("User Initiated: \(Thread()) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .medium) {
//                print("Medium: \(Thread()) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .low) {
//                print("Low: \(Thread()) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .utility) {
//                print("Utiity: \(Thread()) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .background) {
//                print("Background: \(Thread()) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .userInitiated) {
//                print("User Initiated: \(Thread()) : \(Task.currentPriority.rawValue)")
//                
//                Task.detached {
//                    print("Detached: \(Thread()) : \(Task.currentPriority.rawValue)")
//                }
//            }
 
//            Task {
//                print(Thread())
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
//        }
    }
}

#Preview {
    TaskBootcamp()
}
