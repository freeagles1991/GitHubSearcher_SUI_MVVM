//
//  RepositoryDetailView.swift
//  GitHubSearcher
//
//  Created by Дима on 08.02.2025.
//

import SwiftUI


struct RepositoryDetailView: View {
    let repositoryModel: RepositoryModel
    var onAddFavoriteButtonTap: (() -> Void)?
    var onBackButtonTap: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .top) {
                    HStack(alignment: .center) {
                        Text(repositoryModel.fullName)
                            .font(.largeTitle)
                            .padding()
                            .background(.green)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                
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
                        Text(repositoryModel.description ?? "none")
                    }
                    
                    HStack {
                        Text("Owner:")
                            .foregroundStyle(.gray)
                        Text(repositoryModel.owner)
                    }
                    .font(.title2)
                    
                    HStack {
                        Text("E-mail:")
                            .foregroundStyle(.gray)
                        Text(repositoryModel.ownerEmail)
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
    }
}

#Preview {
    let testRepo = RepositoryModel.defaultRepoItem
    
    RepositoryDetailView(repositoryModel: testRepo)
}
