//
//  PlaceTableViewCell.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/22.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var AddressLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }



  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func set(place: Place) {
    self.layer.addBorder([.top, .bottom], color: UIColor.white, width: 0.5)

    self.titleLabel.text = place.title
    if place.roadAddress == nil {
      self.AddressLabel.text = place.jibunAddress
    } else {
      self.AddressLabel.text = place.roadAddress
    }
  }

}
