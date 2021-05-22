//
//  ViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit

class ViewController: UIViewController {

  var startCity: Place?
  var endCity: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      SearchPlaceAPI().searchPlace(keyword: "공덕역") { [weak self] in
        guard let self = self else { return }
        self.startCity = try! $0.get().placeList.first

        SearchPlaceAPI().searchPlace(keyword: "서울역") {
          self.endCity = try! $0.get().placeList.first

          SearchPathAPI().searchPath(startPlace: self.startCity!, goalPlace: self.endCity!) { result in
            print(try! result.get())
          }
        }
      }


    }


}

