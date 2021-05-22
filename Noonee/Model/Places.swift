//
//  placeModel.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import Foundation

struct Places: Codable {
  var placeList: [Place]

  enum CodingKeys: String, CodingKey {
    case placeList = "place"
  }
}

struct Place: Codable {
  var title: String
  var roadAddress: String?
  var jibunAddress: String
  var id: String
  var x: String
  var y: String
}
