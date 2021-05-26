//
//  SelectViewController.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/23.
//

import Foundation
import UIKit
import SnapKit

final class SelectViewController: UIViewController {

    // MARK: UI

    @IBOutlet weak var RecommandButton: SelectRouteButton!
    @IBOutlet weak var TimeLeastButton: SelectRouteButton!
    @IBOutlet weak var TransferLeastButton: SelectRouteButton!


    // MARK: Actions

    @IBAction func RecommandAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Detail", bundle: .main)
            .instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            if let depaturePlace = self.singletonData.depaturePlace, let goalPlace = self.singletonData.destinationPlace {
                self.searchPathAPI.searchPath(startPlace: depaturePlace, goalPlace: goalPlace) { [weak self] in

                    vc.StepList = try! $0.get().pathList[0].legs[0].stepList
                    vc.totalFare = try! $0.get().pathList[0].fare
                    DispatchQueue.main.async {
                        self?.navigationController?.pushViewController(vc, animated: true)

                    }
                }
            }
        }
    }

    @IBAction func TimeLeastAction(_ sender: Any) {
    }

    @IBAction func TransferLeastAction(_ sender: Any) {
    }

    private enum ViewMetrics {
      static let buttonCornerRadius: CGFloat = 20
    }

    // MARK: Properties

    var depaturePlace: Place?
    var destinationPlace: Place?
    var isDeparture: Bool = true
    var singletonData: SingletonUserData = SingletonUserData.shared
    let searchPathAPI = SearchPathAPI()


    // MARK: View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        self.layout()
    }

    private func configuration() {
        self.configureNavigation()
    }

    private func configureNavigation() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Select Route"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }


    // MARK: Layout

    private func layout() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")

        self.RecommandButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        self.TimeLeastButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        self.TransferLeastButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
    }
}
