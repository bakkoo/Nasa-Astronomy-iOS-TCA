//
//  Dependencies.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 23.01.24.
//

import Foundation
import Dependencies
import Networking
import ImageLoader

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
    
    var imageLoader: DefaultImageLoader {
        get { self[DefaultImageLoader.self] }
        set { self[DefaultImageLoader.self] = newValue }
    }
}

extension APIClient: DependencyKey {
    public static var liveValue: APIClient {
        APIClient()
    }
}

extension DefaultImageLoader: DependencyKey {
    public static var liveValue: DefaultImageLoader {
        DefaultImageLoader()
    }
}
