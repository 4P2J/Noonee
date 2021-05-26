//
//  SelectRouteButton.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/26.
//

import UIKit

final class SelectRouteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func customInit() {
        if let view = Bundle.main.loadNibNamed("SelectRouteButton", owner: self, options: nil)?.first as? UIButton {
            print(view.frame, self.bounds)
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}
