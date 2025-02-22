//
//  ContentView.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import SwiftUI
import CoreData
import SwiftData

struct RepositoriesListView: View {
    @StateObject var viewModel: RepositoriesListViewModel
    @EnvironmentObject var flowController: FlowController
    
    @State private var isFavoriteTabActive: Bool = false
    @State private var tabs: [TabModel] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.lightGray)
                    .ignoresSafeArea()
                
                VStack {
                    Text(isFavoriteTabActive ? "Favorites" : "GitHub Search")
                        .font(.largeTitle)
                    
                    if !isFavoriteTabActive {
                        CustomSearchBar_SUI(searchText: $viewModel.searchText)
                        
                        switch viewModel.searchStates {
                        case .empty:
                            Text("Ничего не найдено или поисковая строка пустая")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loading:
                            Text("Загрузка...")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        case .loaded:
                            List(viewModel.repositories.indices, id: \.self) { index in
                                Button {
                                    flowController.navigateTo(.repositoryDetail(viewModel.repositories[index]))
                                } label: {
                                    RepositoryCell_SUI(
                                        repository: viewModel.repositories[index],
                                        cellHeight: GlobalVars.screenWidth * 0.18
                                    )
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .background(Color.clear)
                            .padding(.top)
                        case .error:
                            Text("Ошибка при загрузке! Повторите попытку")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    } else {
                        if !viewModel.swiftDataStore.favoriteRepositories.isEmpty {
                            List(viewModel.swiftDataStore.favoriteRepositories.indices, id: \.self) { index in
                                Button {
                                    flowController.navigateTo(.repositoryDetail(viewModel.swiftDataStore.favoriteRepositories[index]))
                                } label: {
                                    RepositoryCell_SUI(
                                        repository: viewModel.swiftDataStore.favoriteRepositories[index],
                                        cellHeight: GlobalVars.screenWidth * 0.18
                                    )
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .background(Color.clear)
                            .padding(.top)
                        } else {
                            Text("В избранное пока ничего не добавлено")
                                .frame(maxWidth: GlobalVars.screenWidth * 0.8, maxHeight: .infinity)
                        }
                    }
                    
                    CustomTabBar_SUI(tabs: tabs)
                }
            }
        }
        .onAppear {
            tabs = [
                TabModel(imageName: "magnifyingglass", action: {
                    self.isFavoriteTabActive = false
                }),
                TabModel(imageName: "star.fill", action: {
                    self.isFavoriteTabActive = true
                })
            ]
        }
    }
}

#Preview {

}
