//
//  RepositoryDetailView.swift
//  GitHubSearcher
//
//  Created by Дима on 08.02.2025.
//

import SwiftUI


struct RepositoryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SwiftDataStoreController.self) var swiftDataStore
    
    let dataLoader: DataLoaderProtocol
    let repository: Repository
    var onAddFavoriteButtonTap: (() -> Void)?
    var onBackButtonTap: (() -> Void)?
    
    @State var userEmail: String?
    @State var isFavorite: Bool = false
    
    var body: some View {
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .top) {
                    HStack(alignment: .center) {
                        Text(repository.fullName)
                            .font(.largeTitle)
                            .padding()
                            .background(.green)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                handleFavoriteButtonTap()
                            }) {
                                Image(systemName: "star")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(.red)
                                
                            }
                        }
                    }
                    
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Description:")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        Text(repository.description ?? "none")
                    }
                    
                    HStack {
                        Text("Owner:")
                            .foregroundStyle(.gray)
                        Text(repository.owner)
                    }
                    .font(.title2)
                    
                    HStack {
                        Text("E-mail:")
                            .foregroundStyle(.gray)
                        Text(userEmail ?? "none")
                    }
                    .font(.title2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.horizontal)

            
                Spacer()
            }

        }
        .onAppear() {
            loadUserEmail(userName: repository.owner)
        }
    }
    
    private func loadUserEmail(userName: String) {
        dataLoader.fetchUserData(with: userName) { result in
            switch result {
            case .success(let userResponse):
                userEmail = userResponse.email
                print("User email fetched = \(String(describing: userEmail))")
            case .failure(let error):
                print("Email loading error - \(error)")
            }
        }
    }
    
    private func handleFavoriteButtonTap() {
        if !swiftDataStore.repositoryExists(repository) {
            swiftDataStore.addRepository(repository)
        } else {
            swiftDataStore.deleteRepository(repository)
        }
    }
}

#Preview {
    let testRepo = Repository.defaultRepoItem
    
    //RepositoryDetailView(repositoryModel: testRepo)
}
