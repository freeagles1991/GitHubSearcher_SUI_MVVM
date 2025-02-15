//
//  CustomTabBar_SUI.swift
//  GitHubSearcher
//
//  Created by Дима on 07.02.2025.
//

import SwiftUI


struct TestView: View {
    var body: some View {
        VStack {
            Spacer()
            
           // CustomTabBar_SUI()
        }
    }
}

struct TabModel: Identifiable {
    let id = UUID()
    let imageName: String
    let action: () -> Void
}

struct CustomTabBar_SUI: View {
    let viewHeight: CGFloat = 40
    @State var selectedTabIndex: Int = 0
    let tabs: [TabModel]
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            HStack(spacing: 0) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    CustomTabBarIcon_SUI(
                        index: index,
                        selectedIndex: $selectedTabIndex,
                        imageName: tab.imageName,
                        onTapButton: {
                            tab.action()
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: viewHeight)
        
    }
}

struct CustomTabBarIcon_SUI: View  {
    let index: Int
    @Binding var selectedIndex: Int
    let imageName: String
    let onTapButton: (() -> Void)?
    
    var body: some View {
        let isActive: Bool = index == selectedIndex
        
        let tabIconColor: Color = isActive ? Color.yellow : Color.white
        
        let tabBgColor: Color = isActive ?  Color.gray : Color.gray.opacity(0.5)
        
        Button(action: {
            onTapButton?()
            selectedIndex = index
        }) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundStyle(tabIconColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(tabBgColor)
    }
}

#Preview {
    TestView()
}
