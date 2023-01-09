//
//  InBoxCoordinatorComponent.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 21.12.22.
//

import NeedleFoundation

class InBoxCoordinatorComponent: Component<EmptyDependency> {
    let navController: UINavigationController
    //var parentCoordinator: AppCoordinatorImpl { get }
    
    init(parent: Scope, navController: UINavigationController) {
        self.navController = navController
        super.init(parent: parent)
    }
    
    var inBoxCoordinator: Coordinator {
        InBoxCoordinator(navigationController: navController)
    }
}
