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

        setButton.becomeFirstResponder()
        setButton.isAccessibilityElement = true
        UIAccessibility.post(notification: .announcement, argument: setButton)
        setButton.accessibilityHint = "You have successfully set up your journey. Please select your route option."
    }

    @IBAction private func setButtonDidTap(_ sender: UIButton) {
        if let selectVC = UIStoryboard(name: "SelectRoute", bundle: .main).instantiateViewController(withIdentifier: "SelectViewController") as? SelectViewController {
            selectVC.depaturePlace = self.singletonData.depaturePlace
            selectVC.destinationPlace = self.singletonData.destinationPlace

            self.navigationController?.pushViewController(selectVC, animated: true)
        }
    }

    private func setLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        setButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        departureLabel.text = UserData.departure
        departureAddressLabel.text = UserData.departureAddress
        destinationLabel.text = UserData.destination
        destinationAddressLabel.text = UserData.destinationAddress
    }

}
