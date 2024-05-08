//
//  ContentView.swift
//  SwiftUIPosts
//
//  Created by Akhmed on 08.05.24.
//


import SwiftUI
import Combine

// MARK: - Model
struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// MARK: - ViewModel
class PostsViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    init() {
        loadPosts()
    }
    
    /// Fetches posts from the server.
    func loadPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            errorMessage = "Invalid URL for posts."
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(validateResponse)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Error fetching posts: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] returnedPosts in
                self?.posts = returnedPosts
            })
            .store(in: &cancellables)
    }
    
    /// Ensures the HTTP response is valid and can be decoded.
    private func validateResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}

// MARK: - View
struct ContentView: View {
    
    @StateObject var viewModel = PostsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                PostCell(post: post)
            }
            .navigationTitle("Posts")
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert(isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = nil
                })
            })
        }
    }
}

// MARK: - Post Cell View
struct PostCell: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title).font(.headline)
            Text(post.body).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    ContentView()
}
