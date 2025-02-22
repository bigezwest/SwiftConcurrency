//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by Thomas on 2/2/25.
//

import SwiftUI
import Combine

class DownloadImageAzyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> () ) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)

        }
        .resume()
    }
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError( {$0} )
            .eraseToAnyPublisher()
    }
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, repsonse) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: repsonse)
        } catch {
            throw error
        }

    }
}

class DownloadImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let loader = DownloadImageAzyncImageLoader()
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage() async {
        
        let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                self?.image = image
//
//            }
//        }

//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &cancellables)
//    }
}

struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownloadImageViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit( )
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear() {
            Task {
                await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
