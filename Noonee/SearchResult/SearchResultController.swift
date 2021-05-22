//
//  SearchViewController.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import Foundation
import UIKit

final class SearchResultController: UIViewController {

  // MARK: UI

  @IBOutlet weak var placeLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var retryButton: UIButton!


  // MARK: Properties

  var titleText: String = ""
  let searchPathAPI = SearchPathAPI()
  let searchPlaceAPI = SearchPlaceAPI()
  var placeList: [Place] = []


  // MARK: Action

  @IBAction func retryAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }


  // MARK: Initializing

  init(placeName: String) {
    self.titleText = placeName
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configuration()
    self.getPlace()
  }

  // MARK: Configuration

  private func configuration() {
    self.configureView()
    self.configureTableView()
    self.configureRetryButton()
  }

  private func configureTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.backgroundColor = UIColor(named: "backgroundBlack")

    let nib = UINib(nibName: "PlaceTableViewCell", bundle: Bundle.main)
    tableView.register(nib, forCellReuseIdentifier: "cell")
  }

  private func configureView() {
    self.view.backgroundColor = UIColor(named: "backgroundBlack")
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationItem.leftBarButtonItem?.title = "Back"
    navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")
  }

  private func configureRetryButton() {
    self.retryButton.layer.borderColor = UIColor(named: "buttonGray")?.cgColor
    self.retryButton.layer.borderWidth = 2.5
    self.retryButton.layer.cornerRadius = self.retryButton.frame.height / 4
  }


  // MARK: Functions

  private func getPlace() {
    self.searchPlaceAPI.searchPlace(keyword: self.titleText) { result in
      self.placeList = (try? result.get().placeList) ?? []
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}

extension SearchResultController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.placeList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlaceTableViewCell else {
      return UITableViewCell()
    }

    cell.set(place: self.placeList[indexPath.row])
    if indexPath.row == 0 {
      cell.layer.addBorder([.top], color: .white, width: 1)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 111
  }
}