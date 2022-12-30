//
//  RootComponent.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 21.12.22.
//

import NeedleFoundation

final class RootComponent: BootstrapComponent {
    var tabBarController: UITabBarController {
        shared { UITabBarController() }
    }

    var dependecy: AppRootDependency {
        AppDI()
    }

    var rootViewCoordinator: Coordinator {
        AppCoordinatorImpl(tabBarController: tabBarController,
                           dependencies: dependecy,
                           inBoxCoordinatorComponent: inBoxCoordinatorComponent,
                           toDayBuilder: toDayComponent,
                           groupBuilder: groupComponent,
                           searchBuilder: searchComponent)
    }

    var inBoxCoordinatorComponent: InBoxCoordinatorComponent {
        InBoxCoordinatorComponent(parent: self, navController: dependecy.makeInBoxModule())
    }

    var toDayComponent: ToDayComponent {
        ToDayComponent(parent: self)
    }

    var groupComponent: GroupComponent {
        GroupComponent(parent: self)
    }

    var searchComponent: SearchComponent {
        SearchComponent(parent: self)
    }
}
