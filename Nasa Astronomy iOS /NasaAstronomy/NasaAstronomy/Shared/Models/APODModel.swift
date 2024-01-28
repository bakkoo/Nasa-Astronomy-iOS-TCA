//
//  APODModel.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 23.01.24.
//

import Foundation

struct APODModel: Codable, Equatable, Identifiable {
    var id: UUID {
        UUID()
    }
    
    let explanation: String?
    let url: String
    let hdurl: String?
    let date: String?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case explanation
        case url
        case hdurl
        case date
    }
}

