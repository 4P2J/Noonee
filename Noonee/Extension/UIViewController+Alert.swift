//
//  UIViewController+Alert.swift
//  Noonee
//
//  Created by sangho Cho on 2021/05/27.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true)
        }
    }
}
