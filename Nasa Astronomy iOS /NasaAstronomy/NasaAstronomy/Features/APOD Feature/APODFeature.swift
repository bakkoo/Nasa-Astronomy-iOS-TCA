//
//  APODFeature.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 23.01.24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import SwiftUI
import Networking
import ImageLoader

struct APODFeature: Reducer {
    //MARK: - Dependencies
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.imageLoader) var imageLoader
    //MARK: - State
    struct State: Equatable {
        var isLoading: Bool = false
        var apodModel: APODModel?
        var image: Image?
        var hdImage: Image?
        var apodError: String?
    }
    //MARK: - Action
    enum Action {
        case fetchApod
        case apodResponse(APODModel)
        case fetchImage(urlString: String)
        case fetchHDImage(urlString: String)
        case imageResponse(image: Image)
        case hdImageResponse(image: Image)
        case loadingCompleted
        case errorReceivedApod(err: Error)
    }
    //MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchApod:
                state.isLoading = true
                return .run { send in
                    do {
                        let apodModel = try await apiClient.request(endpoint: .nasaApod, apiConfiguration: .nasaAPI, type: APODModel.self)
                        await send(.apodResponse(apodModel))
                    } catch {
                        await send(.errorReceivedApod(err: error))
                    }
                }
            case .apodResponse(let response):
                state.apodModel = response
                return .run { send in
                    await send(.fetchImage(urlString: response.url))
                    await send(.fetchHDImage(urlString: response.hdurl ?? ""))
                }
            case .loadingCompleted:
                state.isLoading = false
                return .none
            case .fetchImage(urlString: let urlString):
                state.isLoading = true
                return .run { send in
                    let loadedImage = try await imageLoader.loadImage(url: URL(string: urlString)!)
                    await send(.imageResponse(image: loadedImage))
                    await send(.loadingCompleted)
                }
            case .imageResponse(image: let image):
                state.image = image
                return .none
            case .errorReceivedApod(err: let err):
                state.apodError = err.localizedDescription
                state.isLoading = false
                return .none
            case .fetchHDImage(urlString: let urlString):
                state.isLoading = true
                return .run { send in
                    let loadedImage = try await imageLoader.loadImage(url: URL(string: urlString)!)
                    await send(.hdImageResponse(image: loadedImage))
                    await send(.loadingCompleted)
                }
            case .hdImageResponse(image: let image):
                state.hdImage = image
                return .none
            }
        }
    }
}
