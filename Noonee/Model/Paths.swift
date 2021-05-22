//
//  paths.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import Foundation

struct Paths: Codable {
  var pathList: [Path]

  struct Path: Codable {
    var type: String
    var duration: Int
    var fare: Int
    var transferCount: Int
    var legs: [Steps]

    struct Steps: Codable {
      var stepList: [Step]

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

      enum CodingKeys: String, CodingKey {
        case stepList = "steps"
      }
    }
  }

  enum CodingKeys: String, CodingKey {
    case pathList = "paths"
  }
}

