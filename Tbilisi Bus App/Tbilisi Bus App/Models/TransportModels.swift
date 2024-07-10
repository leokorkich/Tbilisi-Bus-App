//
//  TransportModels.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 05.07.24.
//

import Foundation

// MARK: - BUS
struct Bus: Codable {
  let shortName: Int
  let color: String
  let headsign: String
  let realtime: Bool
  let realtimeArrivalMinutes: Int
  let scheduledArrivalMinutes: Int
}




// MARK: - BUS ARRIVAL TIME

struct BusArrivalTime: Codable {
  let shortName: String
  let color: String
  let headsign: String
  let realtime: Bool
  let realtimeArrivalMinutes: Int
  let scheduledArrivalMinutes: Int
}



// MARK: - METRO ARRIVAL TIME

struct MetroArrivalTime: Codable {
  let shortName: String
  let color: String
  let headsign: String
  let realtime: Bool
  let realtimeArrivalMinutes: Int
  let scheduledArrivalMinutes: Int
}
