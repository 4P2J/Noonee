//
//  DetailTableViewCell.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/23.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var busLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        circleView.layer.cornerRadius = circleView.bounds.size.width / 2
        circleView.layer.borderColor = UIColor(named: "HomeButtonGray")?.cgColor
        circleView.layer.borderWidth = 1
    }

    func setProperties(_ index: Int) {
        orderLabel.text = String(index)
        titleLabel.text = "ㅇㄹㅁㄴㅇㅁ"
        busLabel.text = "ㄷㅈㅂㄱㅂㅈㄷㄱ"
    }
}

