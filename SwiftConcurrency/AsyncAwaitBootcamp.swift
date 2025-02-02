//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/2/25.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title 1: \(Thread.current)")
        }
    }
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let title3 = "Title3: \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
    
        let author1 = "Author1: \(Thread())"

        let author2 = "Author2: \(Thread())"
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        await MainActor.run(body: {
            self.dataArray.append(author1)

            self.dataArray.append(author2)
            
            let author3 = "Author3: \(Thread())"
            self.dataArray.append(author3)
        })
        await addSomething()
    }

    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let somthing1 = "Something1: \(Thread())"
        await MainActor.run(body: {
            self.dataArray.append(somthing1)
            let something2 = "Something2: \(Thread())"
            self.dataArray.append(something2)
        })
    }
}


struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id:\.self) { data in
                Text(data)
            }
        }
        .onAppear() {
            Task {
                await viewModel.addAuthor1()
                let finalText = "FINAL TEXT: \(Thread())"
                viewModel.dataArray.append(finalText)
            }
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
