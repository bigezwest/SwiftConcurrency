//
//  ActorsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/4/25.
//

import SwiftUI

class MyDataManager {

    static let instance = MyDataManager()
    private init() {}
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.example.MyDataManager")

    func getRandomData(
        completionHandler: @escaping (_ title: String?) -> Void
    ) {

        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread())

            completionHandler(self.data.randomElement())
        }
    }
}
class MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() {}
    
    var data: [String] = []
    
    nonisolated
    let myRandomText = "lsdkjfalkdsj"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread())
        return self.data.randomElement()
    }
    
    nonisolated
    func getSavedData() -> String {
        return "New Data"
    }
}

struct HomeView: View {

    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(
        every: 0.1, tolerance: nil, on: .main, in: .common, options: nil
    ).autoconnect()

    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            let newString = manager.getSavedData()
            Task {
                let newString = manager.myRandomText
            }
        })
        .onReceive(timer) { _ in
            Task {
                if let data = manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        }
    }
}
struct BrowseView: View {

    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(
        every: 0.01, tolerance: nil, on: .main, in: .common, options: nil
    ).autoconnect()

    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
            }

//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
