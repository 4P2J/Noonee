//
//  SearchPathAPI.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import Foundation

class SearchPathAPI {

  func searchPath(startPlace: Place, goalPlace: Place, completion: @escaping (Result<(Paths),(Error)>) -> ()) {

    var urlRequest = URLComponents(string: APIURL.searchPathUrl.rawValue)

    let startComponent = URLQueryItem(name: "start", value: "\(startPlace.x),\(startPlace.y),placeid=\(startPlace.id),name=\(startPlace.title.utf8)")
    let goalComponent = URLQueryItem(name: "goal", value: "\(goalPlace.x),\(goalPlace.y),placeid=\(goalPlace.id),name=\(goalPlace.title.utf8)")
    let crsConponent = URLQueryItem(name: "crs", value: "EPSG:4326")

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.string(from: Date())
    dateFormatter.dateFormat = "HH:mm:ss"
    let time = dateFormatter.string(from: Date())

    let timeComponent = URLQueryItem(name: "departureTime", value: "\(date)T\(time)")
    let modeComponent = URLQueryItem(name: "mode", value: "TIME")
    let languageComponent = URLQueryItem(name: "lang", value: "ko")

    urlRequest?.queryItems = [startComponent,goalComponent,crsConponent,modeComponent,timeComponent,languageComponent]

    guard let url = urlRequest?.url else { return }

    URLSession(configuration: .default).dataTask(with: url) { data, response, error in
      guard error == nil else { return }

      let successRange = 200..<300
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
        return }

      guard let resultData = data else { return }

      do {
        let paths = try JSONDecoder().decode(Paths.self, from: resultData)
        completion(.success(paths))
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }
}
