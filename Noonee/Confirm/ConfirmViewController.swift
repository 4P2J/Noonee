//
//  ConfirmViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit

final class ConfirmViewController: UIViewController {

    @IBOutlet private weak var setButton: UIButton!

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }

    @IBAction private func setButtonDidTap(_ sender: UIButton) {
        // 경로 상세 화면 이동
    }

    private func setLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")
        
        setButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
    }

}
