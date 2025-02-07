//
//  SwiftUIView.swift
//  GitHubSearcher
//
//  Created by Дима on 06.02.2025.
//

import SwiftUI

//MARK: SearchBar
struct CustomSearchBar_SUI: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false
    let frameHeight: CGFloat
    
    init(searchText: Binding<String>,
         isEditing: Bool = false,
         frameHeight: CGFloat = 50) {
        self._searchText = searchText
        self.isEditing = isEditing
        self.frameHeight = frameHeight
    }
    
    var body: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .frame(height: frameHeight)
                .padding(.horizontal, frameHeight * 0.8)
                .background(.white)
                .opacity(0.5)
                .cornerRadius(frameHeight * 0.5)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, frameHeight * 0.25)
                        
                        if isEditing {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    isEditing = true
                }
        }
        .padding(.horizontal)
    }
}


#Preview {
//    CustomSearchBar_SUI(searchText: <#T##Binding<String>#>)
}
