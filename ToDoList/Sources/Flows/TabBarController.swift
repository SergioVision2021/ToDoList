//swiftlint:disable all
//  TabBarController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//
import UIKit

extension TabBarController {
    enum Image: String {
        case calendar, flame, triangle, magnifyingglass }

    enum Title: String {
        case InBox, ToDay, TaskList, Search }
}

class TabBarController: UITabBarController {

    //private lazy var fileService = FileService()
    
    private lazy var fileService = BackendService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backendService.edit(backendService.handleSuccesstaskTest, true)
        
//        let todayModule = TodayModule().setService(fileService)
//        let searchModule = TodayModule().setService(fileService)

        viewControllers = [makeInboxView(), makeTodayView(), makeTaskListController(), makeSearchController()]
    }
}

private extension TabBarController {
    func makeNavController(vc: UIViewController, title: String, image: UIImage?, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    
    func makeInboxView() -> UIViewController {
        let vc = InBoxViewController()
        vc.title = Title.InBox.rawValue
        vc.service = fileService

        return makeNavController(vc: vc, title: Title.InBox.rawValue, image: UIImage(systemName: Image.calendar.rawValue), tag: 0)
    }

    func makeTodayView() -> UIViewController {
        let vc = ToDayViewController()
        vc.title = Title.ToDay.rawValue
        vc.service = fileService

        return makeNavController(vc: vc, title: Title.ToDay.rawValue, image: UIImage(systemName: Image.flame.rawValue), tag: 1)
    }

    func makeTaskListController() -> UIViewController {
        let vc = TaskListViewController()
        vc.title = Title.TaskList.rawValue
        vc.service = fileService

        return makeNavController(vc: vc, title: Title.TaskList.rawValue, image: UIImage(systemName: Image.triangle.rawValue), tag: 2)
    }

    func makeSearchController() -> UIViewController {
        let vc = SearchViewController()
        vc.title = Title.Search.rawValue
        vc.service = fileService

        return makeNavController(vc: vc, title: Title.Search.rawValue, image: UIImage(systemName: Image.magnifyingglass.rawValue), tag: 3)
    }
}
