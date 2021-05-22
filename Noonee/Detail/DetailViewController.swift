//
//  DetailViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit

final class DetailViewController: UIViewController {


  // MARK: Layout

    @IBOutlet private weak var payButton: UIButton!
    @IBOutlet private weak var detailTableView: UITableView!
  @IBOutlet weak var totaldurationLabel: UILabel!
  @IBOutlet weak var totalCost: UILabel!

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }


  // MARK: Properties

  var StepList: [Step] = []
  var routeIndex = 0
  var totalFare = 0

    private func setLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")

        payButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        detailTableView.estimatedRowHeight = 90

      self.totaldurationLabel.text = "\(self.StepList.reduce(0){ $0 + $1.duration })분"
      self.totalCost.text = "\(self.totalFare)원"
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      return self.StepList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailCell = tableView
                .dequeueReusableCell(withIdentifier: "DetailTableViewCell",
                                     for: indexPath) as? DetailTableViewCell
        else {
            return UITableViewCell()
        }

      let step = self.StepList[indexPath.row]

      detailCell.setProperties(indexPath.row, routeIndex: routeIndex, step: step)

      if step.type == "BUS" || step.type == "SUBWAY" {
        routeIndex += 1
      }

        return detailCell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
