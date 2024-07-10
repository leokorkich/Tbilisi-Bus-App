//
//  MapModels.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 03.07.24.
//

import Foundation


struct Location: Decodable {
    let name: String
    let id: String
    let latitude: Double
    let longitude: Double
    let name_en: String
    let name_uk: String
}

struct Locations: Decodable {
    let Location: [Location]
}


struct Station: Decodable {
    let id: String
    let line: Int
    let name: String
    let latitude: Double
    let longitude: Double

}

struct Stations: Decodable {
    let Station: [Station]
}
