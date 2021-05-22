//
//  HomeViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var journeyButton: UIButton!
    @IBOutlet private weak var historyButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    private func setLayout() {
        journeyButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        historyButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        settingButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
    }
}
