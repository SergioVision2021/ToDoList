//
//  FilterDate.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 13.12.22.
//

import Foundation

class FilterDate {

    func filter(data: [Task]?) -> [Model.ViewModel.Group]? {
        guard let data = data else { return nil }

        var groups: [Model.ViewModel.Group] = []

        var sections = [String]()
        var tasks = [(Int, Model.ViewModel.Task)]()

        data.forEach { task in
            let intervale = ConvertDate().intervaleString(end: task.taskScheduledDate)

            //Проверка на наличии дубликата
            if !sections.contains(intervale) {
                // Массив всех периодов
                sections.append(intervale)
            }

            // Массив всех задач Id = section, Task = value
            guard let id = sections.firstIndex( where: { $0 == intervale } ) else { return }
            tasks.append((id, Model.ViewModel.Task(id: task.id,
                                                            groupId: task.groupId,
                                                            name: task.name,
                                                            status: task.status)
            ))
        }

        for (indexS, _) in sections.enumerated() {          // Section
            var sectionTasks = [Model.ViewModel.Task]()

            let filter = tasks.filter { $0.0 == indexS }

            filter.forEach { task in
                sectionTasks.append(task.1)
            }

            groups.append(Model.ViewModel.Group(id: indexS, name: sections[indexS], tasks: sectionTasks))
        }

        return groups
    }

    func filterPeriod(data: [Task]?, name: String) -> [Model.ViewModel.Group]? {
        guard let source = filter(data: data) else { return nil }

        // Из всех секций (периодов) получить секцию ToDay
        let groupPeriod = source.filter { $0.name == name }

        guard !groupPeriod.isEmpty else { return nil }

        guard let toDay = groupPeriod.first else { return nil }

        // Создать 2 группы по статусу тасков
        var groupStatus = [Model.ViewModel.Group]()

        if let list = toDay.tasks {
            var taskCompleted = [Model.ViewModel.Task]()
            var taskIncomplete = [Model.ViewModel.Task]()

            for task in list {
                switch task.status {
                case true: taskCompleted.append(task)
                case false: taskIncomplete.append(task)
                default: break
                }
            }

            groupStatus.append(Model.ViewModel.Group(id: 0, name: "Completed", tasks: taskCompleted))
            groupStatus.append(Model.ViewModel.Group(id: 1, name: "Incomplete", tasks: taskIncomplete))
        }
        return groupStatus
    }

    func filterGroups(data: [Group]) -> [String]? {
        return data.compactMap { $0.name }
    }

    func filterTasks(data: [Task]) -> [String]? {
        return data.compactMap { $0.name }
    }
}
