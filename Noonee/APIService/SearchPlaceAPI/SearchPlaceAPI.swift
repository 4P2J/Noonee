//
//  SearchPlaceAPI.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import Foundation

class SearchPlaceAPI {
  
  func searchPlace(keyword: String, completion: @escaping (Result<Places,(Error)>) -> ()) {

    var urlComponent = URLComponents(string: APIURL.searchPlaceUrl.rawValue)

    let languageQuery = URLQueryItem(name: "lang", value: "ko")
    let callerQuery = URLQueryItem(name: "caller", value: "pcweb")
    let typesQuery = URLQueryItem(name: "types", value: "place,address,bus")
    let coordsQuery = URLQueryItem(name: "coords", value: "37.55019151418508,126.96002483367921")
    let nameQuery = URLQueryItem(name: "query", value: "\(keyword.utf8)")

    urlComponent?.queryItems = [languageQuery,callerQuery,typesQuery,coordsQuery,nameQuery]

    guard let requestURL = urlComponent?.url else { return }

    URLSession(configuration: .default).dataTask(with: requestURL) { data, response, error in
      guard error == nil else { return }

      let successRange = 200..<300
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else { return }

      guard let resultData = data else { return }

      do {
        let places = try JSONDecoder().decode(Places.self, from: resultData)
        completion(.success(places))
      } catch {
        print(error.localizedDescription)
        completion(.failure(error))
      }
    }.resume()
  }
}

