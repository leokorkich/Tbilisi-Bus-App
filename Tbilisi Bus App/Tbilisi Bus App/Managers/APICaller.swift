//
//  APICaller.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 03.07.24.
//

import Foundation


enum APIError: Error {
  case failedToLoadData
}

enum APIEndpoint {
  case busStopTime
  case metroStationTime
}



class APICaller {
    static let shared = APICaller()

  // MARK: - GET BUS ARRIVAL TIMES
    func getArrivalTimesForStop(stopId: Int, completion: @escaping (Result<[BusArrivalTime], Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(Constants.TTC_BASE_URL)/pis-gateway/api/v2/stops/1:\(stopId)/arrival-times?locale=en&ignoreScheduledArrivalTimes=false")!, timeoutInterval: Double.infinity)
        request.addValue(Constants.TTC_API_KEY, forHTTPHeaderField: "X-Api-Key")
        request.addValue("cookiesession1=678A3E12D100D4652EEEAE7A70452D43", forHTTPHeaderField: "Cookie")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let results = try JSONDecoder().decode([BusArrivalTime].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

  // MARK: - GET METRO ARRIVAL TIMES
  func getArrivalTimesForStation(stationId: String, completion: @escaping (Result<[MetroArrivalTime], Error>) -> Void) {
      var request = URLRequest(url: URL(string: "\(Constants.TTC_BASE_URL)/pis-gateway/api/v2/stops/\(stationId)/arrival-times?locale=en&ignoreScheduledArrivalTimes=false")!, timeoutInterval: Double.infinity)
      request.addValue(Constants.TTC_API_KEY, forHTTPHeaderField: "X-Api-Key")
      request.addValue("cookiesession1=678A3E12D100D4652EEEAE7A70452D43", forHTTPHeaderField: "Cookie")

      request.httpMethod = "GET"

      let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              print(String(describing: error))
              return
          }
          do {
              let results = try JSONDecoder().decode([MetroArrivalTime].self, from: data)
              completion(.success(results))
          } catch {
              completion(.failure(error))
          }
      }

      task.resume()
  }
}

