//
//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

class MemoryService: TaskService {

    // Загрузить готовый объект
    func load() {
        super.source.append(Group.init(
            id: 0, name: "Inbox", list: [Task.init(id: 0,
                                                   name: "task 0",
                                                   taskDeadline: ConvertDate().convert(from: "2022-02-15"),
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-15"),
                                                   notes: "nnnnnn",
                                                   status: true),
                                        Task.init(id: 0,
                                                  name: "task 1",
                                                  taskScheduledDate: ConvertDate().convert(from: "2022-02-17"),
                                                  notes: "nnnnnn",
                                                  status: false),
                                        Task.init(id: 0,
                                                  name: "task 2",
                                                  taskDeadline: ConvertDate().convert(from: "2022-02-14"),
                                                  taskScheduledDate: ConvertDate().convert(from: "2022-02-14"),
                                                  notes: "nnnnnn", status: true)]))
        super.source.append(Group.init(
            id: 1, name: "Hobby", list: [Task.init(id: 1,
                                                   name: "Собрать кухню",
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-20"),
                                                   notes: "Нет времени",
                                                   status: false)]))
        super.source.append(Group.init(
            id: 2, name: "Work", list: [Task.init(id: 2,
                                                  name: "Написать тестовое задание",
                                                  taskScheduledDate: Date(),
                                                  notes: "Самообразование",
                                                  status: false),
                                         Task.init(id: 2,
                                                   name: "Прочитать статьи по SwiftGen",
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-15"),
                                                   notes: "nnnnnn",
                                                   status: false),
                                         Task.init(id: 2,
                                                   name: "Проверить задачи в JIRA",
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-15"),
                                                   notes: "Смотреть и наши и чешские",
                                                   status: false),
                                         Task.init(id: 2,
                                                   name: "Проверить invite от AppleID",
                                                   taskDeadline: Date() + 1,
                                                   taskScheduledDate: Date(),
                                                   notes: "На почте от  Cetelem",
                                                   status: true),
                                         Task.init(id: 2,
                                                   name: "Потренероваться в перекраске WL для банка",
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-01"),
                                                   notes: "Придумай сам",
                                                   status: false),
                                         Task.init(id: 2,
                                                   name: "Почитать док по GPE",
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-19"),
                                                   notes: "Лежат в папке",
                                                   status: false)]))
        super.source.append(Group.init(
            id: 3, name: "Films", list: [Task.init(id: 3,
                                                   name: "Посмотреть Матрицу 4",
                                                   taskDeadline: ConvertDate().convert(from: "2022-02-15"),
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-21"),
                                                   notes: "Советовали",
                                                   status: true),
                                         Task.init(id: 3,
                                                   name: "Посмотреть Анчартед: На картах не значится",
                                                   taskScheduledDate: ConvertDate().convert(from: "2022-02-18"),
                                                   notes: "Советовали",
                                                   status: false)]))
        super.source.append(Group.init(
            id: 4, name: "Building", list: [Task.init(id: 4,
                                                      name: "task 0",
                                                      taskScheduledDate: ConvertDate().convert(from: "2022-02-17"),
                                                      notes: "nnnnnn",
                                                      status: false),
                                            Task.init(id: 4,
                                                      name: "task 1",
                                                      taskScheduledDate: ConvertDate().convert(from: "2022-02-20"),
                                                      notes: "nnnnnn",
                                                      status: false)]))

    }

    override func add(_ newTask: [Group]) {
        super.add(newTask)
    }

    override func edit(_ task: Task, _ status: Bool) {
        super.edit(task, status)
    }

    override func filterPeriod() -> [Group]? {
        return super.filterPeriod()
    }

    override func filterToday(_ namePeriod: String) -> [Group]? {
        return super.filterToday(namePeriod)
    }

    override func filterAllTasks() -> [String] {
        return super.filterAllTasks()
    }

    override func filterGroup() -> [String] {
        return super.filterGroup()
    }
}
