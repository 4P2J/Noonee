//
//  ConfirmViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit

final class ConfirmViewController: UIViewController {

    @IBOutlet private weak var setButton: UIButton!
    @IBOutlet private weak var departureLabel: UILabel!
    @IBOutlet private weak var departureAddressLabel: UILabel!
    @IBOutlet private weak var destinationLabel: UILabel!
    @IBOutlet private weak var destinationAddressLabel: UILabel!

  // MARK: Properties

  let singletonData = SingletonUserData.shared
  let searchPathAPI = SearchPathAPI()

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }

    @IBAction private func setButtonDidTap(_ sender: UIButton) {

      let selectVC = SelectViewContrller(depature: singletonData.depaturePlace!, destination: singletonData.destinationPlace!)

      self.navigationController?.pushViewController(selectVC, animated: true)
    }

    private func setLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")
        
        setButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        departureLabel.text = UserData.departure
        departureAddressLabel.text = UserData.departureAddress
        destinationLabel.text = UserData.destination
        destinationAddressLabel.text = UserData.destinationAddress
    }

}
