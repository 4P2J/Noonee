//
//  SingletonUserData.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/23.
//

import Foundation

class SingletonUserData {
  static let shared = SingletonUserData()

  var depaturePlace: Place?
  var destinationPlace: Place?

  private init() {}
}
