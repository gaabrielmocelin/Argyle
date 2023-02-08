//
//  SceneDelegate.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import UIKit
import ArgyleSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        Argyle.shared.apiKey = "kXatSEqBrGIaHeCp"

        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()

        let searchController = Argyle.shared.searchController()
        window?.rootViewController = UINavigationController(rootViewController: searchController)
    }
}

