//
//  DetailViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var payButton: UIButton!
    @IBOutlet private weak var detailTableView: UITableView!

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }

    private func setLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")

        payButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        detailTableView.estimatedRowHeight = 90
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailCell = tableView
                .dequeueReusableCell(withIdentifier: "DetailTableViewCell",
                                     for: indexPath) as? DetailTableViewCell
        else {
            return UITableViewCell()
        }

        detailCell.setProperties(2)

        return detailCell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
