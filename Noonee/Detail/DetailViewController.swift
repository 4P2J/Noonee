//
//  DetailViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit
import LocalAuthentication

final class DetailViewController: UIViewController {

    // MARK: Constant

    private enum ViewMetrics {
        static let buttonCornerRadius: CGFloat = 20
    }


    // MARK: UI

    @IBOutlet private weak var payButton: UIButton!
    @IBOutlet private weak var detailTableView: UITableView!
    @IBOutlet weak var totaldurationLabel: UILabel!
    @IBOutlet weak var totalCost: UILabel!


    // MARK: Action

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
                            rootVC?.steps = self.stepList
                            rootVC?.homeState = .departure
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                rootVC?.isRecievedEvent = .payment
                            }
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        if let error = error {
                            print(error.localizedDescription) }
                    }
                }
        } else {
            print(error?.localizedDescription ?? "")
        }
    }


    // MARK: Properties

    var path: Path?
    lazy var stepList: [Step] = self.path?.legs[0].stepList ?? []
    let authContext = LAContext()
    var message : String?
    var error: NSError?


    // MARK: View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

        payButton.isAccessibilityElement = true
        payButton.accessibilityHint = "This route is recommend route. Please check the detail of route by tapping the list. If you want to set and pre-pay this route, tap the bottom of the screen."
    }


    // MARK: Layout

    private func setLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")

        payButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        detailTableView.estimatedRowHeight = 90

        self.totaldurationLabel.text = "\(self.stepList.reduce(0){ $0 + $1.duration })분"
        self.totalCost.text = "\(self.path?.fare ?? 0)원"
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.stepList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailCell = tableView
                .dequeueReusableCell(withIdentifier: "DetailTableViewCell",
                                     for: indexPath) as? DetailTableViewCell
        else {
            return UITableViewCell()
        }

        let step = self.stepList[indexPath.row]

        detailCell.setProperties(indexPath.row, step: step)

        return detailCell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
