//
//  TabBar.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 24.01.24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct TabBar: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab: Hashable {
        case home, favorites, settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ApodView()
            }
            .tabItem {
                tabBarItem(tab: .home, systemImage: "moon.circle.fill", title: "Apod")
            }
            .tag(Tab.home)
            
            NavigationView {
                ApodSearchView()
            }
            .tabItem {
                tabBarItem(tab: .favorites, systemImage: "magnifyingglass", title: "Search")
            }
            .tag(Tab.favorites)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                tabBarItem(tab: .settings, systemImage: "gearshape.fill", title: "Settings")
            }
            .tag(Tab.settings)
        }
        .tint(Color.white)
        .preferredColorScheme(.dark)
    }
    
    private func tabBarItem(tab: Tab, systemImage: String, title: String) -> some View {
        Label(title, systemImage: systemImage)
            .tag(tab)
    }
}

struct ApodView: View {
    var body: some View {
        APODView(store: Store(initialState: APODFeature.State(),
                              reducer: {
            APODFeature()._printChanges()
        }))
    }
}

struct ApodSearchView: View {
    var body: some View {
        SearchApodView(store: Store(initialState: APODSearchFeature.State(),
                                    reducer: {
            APODSearchFeature()._printChanges()
        }))
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
            .navigationTitle("Settings")
    }
}

struct ContentView: View {
    var body: some View {
        TabBar()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
