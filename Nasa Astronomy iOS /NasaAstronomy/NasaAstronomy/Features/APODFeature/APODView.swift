//
//  APODView.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 23.01.24.
//

import SwiftUI
import ComposableArchitecture
import Color_Extensions

struct APODView: View {
    let store: StoreOf<APODFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("Astronomy picture of the day ")
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(.linearGradient(colors: [Color.Celestial.first, Color.Celestial.second, Color.Celestial.third], startPoint: .leading, endPoint: .trailing))
                    Spacer()
                } //MARK: - HStack
                if viewStore.isLoading {
                    ProgressView()
                        .tint(LinearGradient(colors: [Color.Celestial.first, Color.Celestial.second, Color.Celestial.third], startPoint: .leading, endPoint: .trailing))
                    Text("Loading image...")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.linearGradient(colors: [Color.Celestial.first, Color.Celestial.second, Color.Celestial.third], startPoint: .leading, endPoint: .trailing))
                } else {
                    if let image = viewStore.image,
                       let apodModel = viewStore.apodModel {
                        Spacer()
                        VStack {
                            Text(apodModel.title ?? "")
                                .bold()
                                .font(.title2)
                                .foregroundStyle(.linearGradient(colors: [Color.Celestial.first, Color.Celestial.second, Color.Celestial.third], startPoint: .leading, endPoint: .trailing))
                                .padding(.bottom, 20)
                            
                            NavigationLink(destination: APODDetailedView(store: store).toolbar(.hidden, for: .tabBar)) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(.linearGradient(colors: [Color.Celestial.first, Color.Celestial.second, Color.Celestial.third], startPoint: .bottom, endPoint: .top), lineWidth: 2)
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                } //MARK: - ZStack
                                .padding()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
                                Spacer()
                            }
                        } //MARK: - VStack
                        Spacer()
                    } else if let apodError = viewStore.apodError {
                        Text(apodError)
                            .font(.title)
                    }
                }
                if !viewStore.isLoading && viewStore.apodModel == nil {
                    Button("Fetch the Apod") {
                        viewStore.send(.fetchApod)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .tint(Color.white)
                }
            } //MARK: - VStack
            .padding()
        }
        .background(.linearGradient(colors: [Color.Nasa.first, Color.Nasa.second, Color.Nasa.third], startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    MainActor.assumeIsolated {
        APODView(store:
                    Store(initialState: APODFeature.State(),
                          reducer: {
            APODFeature()._printChanges()
        }))
    }
}
