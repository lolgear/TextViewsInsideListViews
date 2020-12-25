//
//  Model.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 03.12.2020.
//

import Foundation

enum Model {
    class Item: Hashable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.title == rhs.title
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.title)
        }
        var title: String
        init(_ title: String) {
            self.title = title
        }
    }

    /// And generate random items.
    class ItemList: Hashable {
        static func == (lhs: ItemList, rhs: ItemList) -> Bool {
            lhs.list == rhs.list
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.list)
        }
        
        static var shared: ItemList = .default()
        var list: [Item]
        required init(_ list: [Item]) {
            self.list = list
        }
        static func `default`() -> Self {
            .init(generate())
        }
        static func generate() -> [Item] {
            self.resources().compactMap(Item.init)
        }
    }
}

extension Model.ItemList {
    static func repeatingCount() -> Int { 5 }
    static func resource() -> String {
        .init(repeating: SceneDelegateResource.resource(), count: self.repeatingCount())
    }
    static func resources() -> [String] {
        self.resource().split(separator: "\n").compactMap(String.init)
    }
}

extension Model.ItemList {
    enum SceneDelegateResource {
        static func resource() -> String {
            """
        class SceneDelegate: UIResponder, UIWindowSceneDelegate {

        var window: UIWindow?


        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        //        guard let window = UIWindow(windowScene: windowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = RootViewController.init(.init())
        window.makeKeyAndVisible()
        }

        func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }

        func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }

        func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        }

        func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        }

        func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        }


        }
        """
        }
    }
}
