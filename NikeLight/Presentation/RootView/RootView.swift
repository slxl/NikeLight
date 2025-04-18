//
//  RootView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ProductListView()
            }
            .tabItem {
                Label("Shop", systemImage: "bag")
            }

            NavigationStack {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "cart")
            }
        }
    }
}
