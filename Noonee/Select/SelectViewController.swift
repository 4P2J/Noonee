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
            self.searchPathAPI.searchPath(startPlace: depaturePlace, goalPlace: goalPlace) { [weak self] in
                do {
                    let paths = try $0.get()
                    if paths.pathList.count > 0 {
                        self?.bestPath = paths.pathList.filter{ $0.labels.contains("최적") }.first
                        self?.timeLeastPath = paths.pathList.filter{ $0.labels.contains("최소환승") }.first
                        self?.transferLeastPath = paths.pathList.filter{ $0.labels.contains("최소시간") }.first
                    } else {
                        self?.alert(message: "해당 구간은 경로안내를 지원하지 않습니다.")
                    }
                } catch {
                    self?.alert(message: "해당 구간의 경로안내를 불러오는데에 실패하였습니다.")
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
