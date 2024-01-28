//
//  ApodItemReducer.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 29.01.24.
//

import Foundation
import ComposableArchitecture
import Networking
import ImageLoader
import SwiftUI
import Dependencies

struct ApodItemReducer: Reducer {
    //MARK: - Dependencies
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.imageLoader) var imageLoader
    //MARK: - State
    struct State: Equatable {
        var isLoading: Bool = false
        var image: Image?
        var title: String?
        var description: String?
    }
    //MARK: - Action
    enum Action {
        case imageResponse(image: Image)
        case imageLoadingCompleted
        case imageErrorReceived(err: Error)
        case fetchImage(url: String)
    }
    //MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .imageResponse(image):
                state.image = image
                return .none
            case .imageLoadingCompleted:
                state.isLoading = false
                return .none
            case let .imageErrorReceived(err):
                state.image = Image(systemName: "circle")
                return .none
            case let .fetchImage(url):
                return .run { send in
                    let image = try await imageLoader.loadImage(url: URL(string: url)!)
                    await send(.imageResponse(image: image))
                    await send(.imageLoadingCompleted)
                }
            }
        }
    }
}
