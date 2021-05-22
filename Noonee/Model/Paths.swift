//
//  paths.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import Foundation

struct Paths: Codable {
  var pathList: [Path]

  enum CodingKeys: String, CodingKey {
    case pathList = "paths"
  }
}

struct Path: Codable {
  var type: String
  var duration: Int
  var fare: Int
  var transferCount: Int
  var legs: [Steps]
  var labels: [String]
}

struct Steps: Codable {
  var stepList: [Step]

  enum CodingKeys: String, CodingKey {
    case stepList = "steps"
  }
}

struct Step: Codable {
  var type: String
  var instruction: String
  var duration: Int
  var routes: [Route]
  var stations: [Station]

  struct Route: Codable {
    var name: String
  }

  struct Station: Codable {
    var name: String
    var displayCode: String
  }
}

