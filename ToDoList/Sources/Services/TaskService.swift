//swiftlint:disable all
//  TaskService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

protocol TaskServiceProtocol {

    func fetch(_ callback: @escaping ([Any], Bool) -> Void)
    
    func add(_ task: Task)
    func edit(_ task: Task, _ status: Bool)

    func filterPeriod() -> [Group]?
    func filterToday(_ namePeriod: String) -> [Group]?
    func filterAllTasks() -> [String]
    func filterGroup() -> [String]
}

class TaskService: TaskServiceProtocol {

    var source = [Group]()
    var filtredData = [Group]()
    

    func fetch(_ callback: @escaping ([Any], Bool) -> Void) {
        callback(source, true)
    }


    // Для InBoxViewController
    func filterPeriod() -> [Group]? {

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

        return filtredData
    }

    // Для TodayViewController
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

    // Для SearchViewController
    func filterAllTasks() -> [String] {
        return source.compactMap { $0.tasks?.compactMap { $0.name }}.flatMap{ $0 }
    }

    // Для TaskListViewController
    func filterGroup() -> [String] {
        source.compactMap { $0.name }
    }

    // AddTask - добавить новую задачу (по умолчанию 0 групп)
    func add(_ task: Task) {
        guard let id = task.groupId else { return }
        source[id].addTask(task)
    }

    // DetailTask - завершить задачу
    func edit(_ task: Task, _ status: Bool) {
        guard let id = task.groupId, let taskName = task.name else { return }

        guard !status else {
            source[id].removeTask(byName: taskName)
            return
        }

        guard let idTask = source[id].getTask(byName: taskName) else { return }
        source[id].tasks?[idTask].setDeadline(Date())
    }

    func defaultGroup() {
        source.insert(Group(id: 0,
                            name: "InBox",
                            dateCreated: Date(),
                            tasks: [Task(groupId: 0, name: "Task1", taskDeadline: nil, taskScheduledDate: Date(), notes: "aaaaa", status: false)]),
                      at: 0)
    }
}
