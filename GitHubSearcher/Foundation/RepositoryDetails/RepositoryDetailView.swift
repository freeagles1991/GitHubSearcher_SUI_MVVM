//
//  RepositoryDetailView.swift
//  GitHubSearcher
//
//  Created by Дима on 08.02.2025.
//

import SwiftUI

struct RepositoryDetailView: View {
    @StateObject private var viewModel: RepositoryDetailViewModel

    init(repository: Repository, dataLoader: DataLoaderProtocol, swiftDataStore: SwiftDataStoreController) {
        _viewModel = StateObject(wrappedValue: RepositoryDetailViewModel(repository: repository, dataLoader: dataLoader, swiftDataStore: swiftDataStore))
    }
    
    enum Constants {
        enum Texts: String {
            case noneText = "None"
            case descriptionText = "Description:"
            case ownerText =  "Owner:"
            case emailText = "E-mail:"
        }
    }

    var body: some View {
        let email = viewModel.isFavoriteRepository() ?
        viewModel.repository.ownerEmail :
        viewModel.userEmail ?? Constants.Texts.noneText.rawValue
        
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .top) {
                    HStack {
                        Text(viewModel.repository.fullName)
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }

                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                viewModel.handleFavoriteButtonTap()
                            }) {
                                Image(systemName: viewModel.favoriteIconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .foregroundStyle(Color.yellow)
                            }
                        }
                    }
                }

                VStack(alignment: .leading) {
                    Text(Constants.Texts.descriptionText.rawValue)
                        .font(.title2)
                        .foregroundStyle(.gray)
                    Text(viewModel.repository.description ?? Constants.Texts.noneText.rawValue)

                    HStack {
                        Text(Constants.Texts.ownerText.rawValue)
                            .foregroundStyle(.gray)
                        Text(viewModel.repository.owner)
                    }
                    .font(.title2)

                    HStack {
                        Text(Constants.Texts.emailText.rawValue)
                            .foregroundStyle(.gray)
                        Text(email)
                    }
                    .font(.title2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

#Preview {
    let testRepo = Repository.defaultRepoItem
    
//    RepositoryDetailView(
//        dataLoader: DataLoader(
//            networkClient: NetworkClient(),
//            repositoriesStorage: RepositoriesStorage()),
//        repository: testRepo)
}
