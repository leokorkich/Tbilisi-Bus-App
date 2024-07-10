//
//  BusViewController.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 05.07.24.
//

import UIKit

class BusViewController: UIViewController {
    var itemNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Bus \(itemNumber ?? 0)"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
