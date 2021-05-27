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

    @IBOutlet weak var recommandButton: SelectRouteButton!
    @IBOutlet weak var timeLeastButton: SelectRouteButton!
    @IBOutlet weak var transferLeastButton: SelectRouteButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!


    // MARK: Actions

    @IBAction func RecommandAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Detail", bundle: .main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.path = self.bestPath
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction func TimeLeastAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Detail", bundle: .main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            if self.timeLeastPath != nil {
                vc.path = self.timeLeastPath
            } else {
                vc.path = self.bestPath
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction func TransferLeastAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Detail", bundle: .main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            if self.transferLeastPath != nil {
                vc.path = self.transferLeastPath
            } else {
                vc.path = self.bestPath
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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

    var bestPath: Path?
    var timeLeastPath: Path?
    var transferLeastPath: Path?


    // MARK: Load Path

    func loadPath() {
        if let depaturePlace = self.singletonData.depaturePlace, let goalPlace = self.singletonData.destinationPlace {
            self.loadingIndicator.startAnimating()
            self.loadingIndicator.becomeFirstResponder()
            self.loadingIndicator.isAccessibilityElement = true
            self.loadingIndicator.accessibilityLabel = "exploring the route."

            self.view.isUserInteractionEnabled = false
            self.searchPathAPI.searchPath(startPlace: depaturePlace, goalPlace: goalPlace) { [weak self] in
                do {
                    let paths = try $0.get()
                    if paths.pathList.count > 0 {
                        self?.bestPath = paths.pathList.filter{ $0.labels.contains("최적") }.first
                        self?.timeLeastPath = paths.pathList.filter{ $0.labels.contains("최소시간") }.first
                        self?.transferLeastPath = paths.pathList.filter{ $0.labels.contains("최소환승") }.first
                    } else {
                        self?.alert(message: "This section does not support route guidance.")
                    }
                    DispatchQueue.main.async() {
                        self?.view.isUserInteractionEnabled = true
                        self?.loadingIndicator.stopAnimating()
                        self?.recommandButton.becomeFirstResponder()
                    }
                } catch {
                    self?.alert(message: "We failed to get a route guide for this section.")
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                    }
                }
            }
        }
    }


    // MARK: View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        self.layout()
        self.loadPath()
    }


    // MARK: Configuration

    private func configuration() {
        self.configureNavigation()
        self.configurationAccessibility()
    }

    private func configureNavigation() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Select Route"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    private func configurationAccessibility() {
        self.recommandButton.isAccessibilityElement = true
        self.timeLeastButton.isAccessibilityElement = true
        self.transferLeastButton.isAccessibilityElement = true

        self.recommandButton.accessibilityHint = "It indicates the best public transportation route."
        self.timeLeastButton.accessibilityHint = "It indicates the public transportation route with the least travel time."
        self.transferLeastButton.accessibilityHint = "It indicates the public transportation route with the lowest number of transfers."
    }


    // MARK: Layout

    private func layout() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")

        self.recommandButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        self.timeLeastButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        self.transferLeastButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
    }
}
