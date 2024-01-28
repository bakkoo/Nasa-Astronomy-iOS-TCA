//
//  APODSearchFeature.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 26.01.24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import SwiftUI
import Networking
import ImageLoader

struct APODSearchFeature: Reducer {
    //MARK: - Dependencies
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.imageLoader) var imageLoader
    //MARK: - State
    struct State: Equatable {
        var isLoading: Bool = false
        var apods: [APODModel]? = []
        var apodError: String?
    }
    //MARK: - Action
    enum Action {
        case fetchApods(startDate: String, endDate: String)
        case fetchRandomApods(count: Int)
        case apodsResponse(apods: [APODModel])
        case loadingCompleted
        case apodsErrorReceived(err: Error)
    }
    //MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fetchApods(startDate, endDate):
                state.isLoading = true
                return .run { send in
                    do {
                        let apods = try await apiClient.request(endpoint: .nasaApodBy(startDate: startDate, endDate: endDate), apiConfiguration: .nasaAPI, type: [APODModel].self)
                        print("APOD RESPONSE - \(apods)")
                        await send(.apodsResponse(apods: apods))
                    } catch {
                        await send(.apodsErrorReceived(err: error))
                    }
                }
            case let .apodsResponse(apods):
                state.apods?.append(contentsOf: apods)
                return .send(.loadingCompleted)
            case .loadingCompleted:
                state.isLoading = false
                return .none
            case let .apodsErrorReceived(err):
                state.isLoading = false
                state.apodError = err.localizedDescription
                return .none
            case .fetchRandomApods(count: let count):
                return .run { send in
                    do {
                        let apods = try await apiClient.request(endpoint: .nasaRandomApod(count: "\(count)"), apiConfiguration: .nasaAPI, type: [APODModel].self)
                        await send(.apodsResponse(apods: apods))
                    } catch {
                        await send(.apodsErrorReceived(err: error))
                    }
                }
            }
        }
    }
}
