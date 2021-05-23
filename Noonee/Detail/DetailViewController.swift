//
//  DetailViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit
import LocalAuthentication

final class DetailViewController: UIViewController {


  // MARK: Layout

    @IBOutlet private weak var payButton: UIButton!
    @IBOutlet private weak var detailTableView: UITableView!
  @IBOutlet weak var totaldurationLabel: UILabel!
  @IBOutlet weak var totalCost: UILabel!

  let authContext = LAContext()
  var message : String?

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

  var error: NSError?

  @IBAction private func testFaceId(_ sender: UIButton) {
      if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       error: &error) {
          switch authContext.biometryType {
          case .faceID:
              message = "Face ID 인증해주세요."
          case .touchID :
              message = "Touch ID로 인증해주세요."
          case .none :
              message = ""
          @unknown default:
              message = ""
          }

          authContext
              .evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                              localizedReason: message!) { (isSuccess, error) in
                  if isSuccess {
                    DispatchQueue.main.async {
                      let rootVC = self.navigationController?.viewControllers[0] as? HomeViewController
                      rootVC?.steps = self.StepList
                      rootVC?.homeState = .departure
                      rootVC?.isRecievedEvent = .payment
                      self.navigationController?.popToRootViewController(animated: true)
                    }
                  } else {
                      if let error = error {
                          print(error.localizedDescription) }
                  }
              }
      } else {
        print(error?.localizedDescription)
      }
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
