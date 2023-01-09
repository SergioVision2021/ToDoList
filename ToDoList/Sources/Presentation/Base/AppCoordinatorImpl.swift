//
//  AppCoordinatorImpl.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

class AppCoordinatorImpl: Coordinator {

    public let tabBarController: UITabBarController
    private var dependencies: AppRootDependency
    private let inBoxCoordinatorComponent: InBoxCoordinatorComponent
    private let toDayBuilder: ToDayBuilder
    private let groupBuilder: GroupBuilder
    private let searchBuilder: SearchBuilder

    // private var childCoordinators = [Coordinator]()

    init(tabBarController: UITabBarController,
         dependencies: AppRootDependency,
         inBoxCoordinatorComponent: InBoxCoordinatorComponent,
         toDayBuilder: ToDayBuilder,
         groupBuilder: GroupBuilder,
         searchBuilder: SearchBuilder) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
        self.inBoxCoordinatorComponent = inBoxCoordinatorComponent
        self.toDayBuilder = toDayBuilder
        self.groupBuilder = groupBuilder
        self.searchBuilder = searchBuilder
    }

    public func start() {

        var controllers: [UIViewController] = []
        
        inBoxCoordinatorComponent.inBoxCoordinator.start()
        
        controllers.append(inBoxCoordinatorComponent.navController)
        controllers.append(dependencies.makeToDayModule(vc: toDayBuilder.toDayComponent))
        controllers.append(dependencies.makeGroupModule(vc: groupBuilder.groupComponent))
        controllers.append(dependencies.makeSearchModule(vc: searchBuilder.sarchComponent))

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
