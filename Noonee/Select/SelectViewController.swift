//
//  SelectViewController.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/23.
//

import Foundation
import UIKit
import SnapKit

final class SelectViewContrller: UIViewController {

  // MARK: UI

  private let recommandButton: UIButton = {
    let button = UIButton()
    button.setTitle("Recommand", for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 40)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor(named: "buttonGray")
    return button
  }()
  private let timeLeastButton: UIButton = {
    let button = UIButton()
    button.setTitle("Time Least", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 40)
    button.backgroundColor = UIColor(named: "buttonGray")

    return button
  }()
  private let trandsferLeastButton: UIButton = {
    let button = UIButton()
    button.setTitle("Trandsfer Least", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 40)
    button.backgroundColor = UIColor(named: "buttonGray")
    return button
  }()


  // MARK: Properties

  var depaturePlace: Place
  var destinationPlace: Place
  var isDeparture: Bool = true
  var singletonData: SingletonUserData = SingletonUserData.shared
  let searchPathAPI = SearchPathAPI()


  // MARK: Initialzing

  init(depature: Place, destination: Place) {
    self.depaturePlace = depature
    self.destinationPlace = destination
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configuration()
    self.layout()
  }

  override func viewDidLayoutSubviews() {
    self.recommandButton.layer.cornerRadius = 20
    self.timeLeastButton.layer.cornerRadius = 20
    self.trandsferLeastButton.layer.cornerRadius = 20
  }

  private func configuration() {
    self.configureView()
    self.configureNavigation()
    self.configureButtons()
  }

  private func configureView() {
    self.view.backgroundColor = UIColor(named: "backgroundBlack")
  }

  private func configureNavigation() {
    self.navigationItem.largeTitleDisplayMode = .always
    self.title = "Select Route"
  }

  private func configureButtons() {
    self.recommandButton.addTarget(self, action: #selector(self.recommandButtonSet), for: .touchUpInside)
    self.timeLeastButton.addTarget(self, action: #selector(self.recommandButtonSet), for: .touchUpInside)
    self.trandsferLeastButton.addTarget(self, action: #selector(self.recommandButtonSet), for: .touchUpInside)
  }


  // MARK: Button Set

  @objc private func recommandButtonSet() {
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

  // MARK: Layout

  private func layout() {
    self.view.addSubview(self.recommandButton)
    self.view.addSubview(self.timeLeastButton)
    self.view.addSubview(self.trandsferLeastButton)

    self.recommandButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(38)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(130)
    }
    self.timeLeastButton.snp.makeConstraints{
      $0.top.equalTo(self.recommandButton.snp.bottom).offset(38)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(130)
    }
    self.trandsferLeastButton.snp.makeConstraints{
      $0.top.equalTo(self.timeLeastButton.snp.bottom).offset(38)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(130)
    }
  }
}
