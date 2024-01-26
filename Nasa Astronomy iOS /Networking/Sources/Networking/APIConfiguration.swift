//
//  File.swift
//  
//
//  Created by Bakur Khalvashi on 26.01.24.
//

import Foundation

public struct APIConfiguration {
    let baseURL: URL
    let apiKey: String

    public static let nasaAPI = APIConfiguration(
        baseURL: URL(string: "https://api.nasa.gov")!,
        apiKey: "soZMS79c6Px6Kn8qnRou8wKSMhvBWgN1YrBurmeF"
    )
}
