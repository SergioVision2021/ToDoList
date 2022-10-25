//swiftlint:disable all
//  TaskService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

enum TaskServiceError: Error {
    case cashe
    case cacheFetching
    case cacheAdding
    case cacheEditing
    case cacheDeleting
}

protocol TaskServiceProtocol {
    func fetch(_ completionHandler: @escaping (Result<[Group], Error>) -> ())
    func update(_ operation: Operations, _ task: Task, completionHandler: @escaping (Result<Void, Error>) -> ())
    
    func filterPeriod()
    func filterToday(_ namePeriod: String) -> [Group]?
    func filterAllTasks() -> [String]
}

class TaskService: TaskServiceProtocol {

    internal var source = [Group]()
    private var filtredData = [Group]()

    public func fetch(_ completionHandler: @escaping (Result<[Group], Error>) -> ()) {
        filterPeriod()
        completionHandler(Result.success(filtredData))
    }

    public func update(_ operation: Operations, _ task: Task, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        
        guard let id = task.groupId else {
            completionHandler(Result.failure(TaskServiceError.cashe))
            return
        }

        switch operation {
        case .add:
            // AddTask - добавить новую задачу (по умолчанию 0 групп)
            source[id].addTask(task)
        case .edit:
            // DetailTask - завершить задачу
            source[id].editTask(task)
        case .delete:
            source[id].removeTask(task)
            // Default data
        case .def:
            source[0] = Group(id: 0,
                              name: "InBox",
                              dateCreated: Date(),
                              tasks: [task])
        }
    }
    
    // For InBoxViewController
    func filterPeriod() {

        filtredData.removeAll()

        var sections = [String]()
        var tasks = [(Int, Task)]()

        source.forEach { group in
            group.tasks?.forEach { task in
                let intervale = ConvertDate().intervaleString(end: task.taskScheduledDate)

                //Проверка на наличии дубликата
                if !sections.contains(intervale) {
                    // Массив всех периодов
                    sections.append(intervale)
                }

                // Массив всех задач Id = section, Task = value
                guard let id = sections.firstIndex( where: { $0 == intervale } ) else { return }
                tasks.append((id, task))
            }
        }

        for (indexS, _) in sections.enumerated() {          // Section
            var sectionTasks = [Task]()

            let filter = tasks.filter { $0.0 == indexS }

            filter.forEach { task in
                sectionTasks.append(task.1)
            }

            filtredData.append(Group.init(id: indexS, name: sections[indexS], tasks: sectionTasks))
        }
    }

    // For TodayViewController
    func filterToday(_ namePeriod: String) -> [Group]? {
        filterPeriod()

        guard !filtredData.isEmpty else { return nil }

        // Из всех секций (периодов) получить секцию ToDay
        let groupPeriod = filtredData.filter { $0.name == namePeriod }

        guard !groupPeriod.isEmpty else { return nil }

        guard let toDay = groupPeriod.first else { return nil }

        // Создать 2 группы по статусу тасков из ToDay
        var statusToDay = [Group]()

        if let list = toDay.tasks {
            var taskCompleted = [Task]()
            var taskIncomplete = [Task]()

            for task in list {
                switch task.status {
                case true: taskCompleted.append(task)
                case false: taskIncomplete.append(task)
                default: break
                }
            }
            statusToDay.append(Group.init(id: 0, name: "Completed", tasks: taskCompleted))
            statusToDay.append(Group.init(id: 1, name: "Incomplete", tasks: taskIncomplete))
        }
        return statusToDay
    }

    // For SearchViewController
    func filterAllTasks() -> [String] {
        return source.compactMap { $0.tasks?.compactMap { $0.name }}.flatMap{ $0 }
    }

    // For TaskListViewController
    func filterGroup() -> [String] {
        source.compactMap { $0.name }
    }
}
