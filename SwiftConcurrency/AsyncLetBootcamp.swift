//
//  AsyncLetBootcamp.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/3/25.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    
    @State private var images: [UIImage] = []
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id:\.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit( )
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle(Text("AsyncLet Bootcamp"))
            .onAppear {
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                            
                        let (image1, title1, image2, image3, image4) = await (
                            try fetchImage1,
                            fetchTitle1,
                            try fetchImage2,
                            try fetchImage3,
                            try fetchImage4)
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "NEW TITLE"
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}
#Preview {
    AsyncLetBootcamp()
}
