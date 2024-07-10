//
//  MapHeaderUIView.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 03.07.24.
//

import UIKit

class MapHeaderUIView: UIView {


  private let openMapButton: UIButton = {

    let button = UIButton()
    button.setTitle("Open map", for: .normal)
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 1
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 15


    return button
  }()


  private let heroImageView: UIImageView = {

    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = UIImage(named: "heroImage")

    return imageView
  }()

  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor.clear.cgColor,
      UIColor.systemBackground.cgColor
    ]
    gradientLayer.frame = bounds
    layer.addSublayer(gradientLayer)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(heroImageView)
    addGradient()
    addSubview(openMapButton)
    applyConstraints()

  }

  private func applyConstraints() {

      openMapButton.translatesAutoresizingMaskIntoConstraints = false

      let openMapButtonConstraints = [

          openMapButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),

          openMapButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),

          openMapButton.widthAnchor.constraint(equalToConstant: 120)
      ]

      NSLayoutConstraint.activate(openMapButtonConstraints)
  }


  override func layoutSubviews() {
    super.layoutSubviews()
    heroImageView.frame = bounds
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
