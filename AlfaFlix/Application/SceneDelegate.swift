//
//  SceneDelegate.swift
//  AlfaFlix
//
//  Created by Yoga on 07/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let mainViewController = UINavigationController(rootViewController: MainScreenViewController())
        window.rootViewController = mainViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
