//
//  ApodItemView.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 28.01.24.
//

import SwiftUI
import ComposableArchitecture

struct ApodItemRow: View {
    let store: StoreOf<ApodItemReducer>
    let imageUrl: String?
    let title: String?
    let description: String?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 20) {
                if viewStore.isLoading {
                    ProgressView()
                    Text("Image loading...")
                } else if let image = viewStore.image {
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                    if let title = title, let description = description {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                }
            }
            .padding(8)
            .onAppear(perform: {
                if let imageUrl = imageUrl {
                    viewStore.send(.fetchImage(url: imageUrl))
                }
            })
        }
    }
}

#Preview {
    ApodItemRow(store:
                    Store(initialState: ApodItemReducer.State(),
                          reducer: {
        ApodItemReducer()._printChanges()
    }), imageUrl: "", title: "", description: "")
}
