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

        Argyle.shared.apiKeyId = "9b40eed7b1d14f16ba3abfad216167e8"
        Argyle.shared.apiKeySecret = "kXatSEqBrGIaHeCp" // This secret should have been stored on a Secrets file ignored by git

        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()

        let searchController = Argyle.shared.searchController()
        window?.rootViewController = UINavigationController(rootViewController: searchController)
    }
}

