//
//  APODDetailedView.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 24.01.24.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import Color_Extensions

struct APODDetailedView: View {
    let store: StoreOf<APODFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack {
                    if let image = viewStore.hdImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    if let apodModel = viewStore.apodModel {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(apodModel.title ?? "Title not available")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.linearGradient(colors: [Color.Celestial.first,Color.Celestial.second,Color.Celestial.third], startPoint: .leading, endPoint: .trailing))
                            
                            Text(apodModel.date ?? "Date not available")
                                .font(.headline)
                                .foregroundStyle(.linearGradient(colors: [Color.Celestial.first,Color.Celestial.second,Color.Celestial.third], startPoint: .trailing, endPoint: .leading))
                            Text(apodModel.explanation ?? "Description not available")
                                .font(.body)
                                .foregroundStyle(.linearGradient(colors: [Color.Celestial.first,Color.Celestial.second,Color.Celestial.third], startPoint: .top, endPoint: .bottom))
                        }
                        .padding()
                    }
                }
            } //MARK: - Scroll
            .background(.linearGradient(colors: [Color.Nasa.first,Color.Nasa.second,Color.Nasa.third], startPoint: .leading, endPoint: .trailing))
            .ignoresSafeArea()
        }
    }
}


#Preview {
    APODDetailedView(store:
                        Store(initialState: APODFeature.State(),
                              reducer: {
        APODFeature()._printChanges()
    }))
}
