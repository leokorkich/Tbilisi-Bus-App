//
//  ViewController.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 03.07.24.
//

import UIKit

class MainTabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red

    let vc1 = UINavigationController(rootViewController: HomeViewController())
    let vc2 = UINavigationController(rootViewController: MapViewController())
    let vc3 = UINavigationController(rootViewController: MetroMapViewController())
    let vc4 = UINavigationController(rootViewController: FavoritesViewController())


    vc1.tabBarItem.image = UIImage(systemName: "house")
    vc2.tabBarItem.image = UIImage(systemName: "map.fill")
    vc3.tabBarItem.image = UIImage(systemName: "train.side.rear.car")
    vc4.tabBarItem.image = UIImage(systemName: "star.fill")


    vc1.title = "Home"
    vc2.title = "Map"
    vc3.title = "Metro"
    vc4.title = "Favorites"


    tabBar.tintColor = .label
    tabBar.isTranslucent = true




    setViewControllers([vc1, vc2, vc3, vc4], animated: true)


  }


}
