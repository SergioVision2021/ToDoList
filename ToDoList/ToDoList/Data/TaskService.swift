//
//  TaskService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

class TaskService{
    var group = [Group]()

    init(){
        group.append(Group.init(
            id: 1, name: "Inbox", list: [Task.init(id: 1, name: "task 0", taskScheduledDate: ConvertDate().convert(from: "2022-02-10"), notes: "nnnnnn", status: true),
                                        Task.init(id: 1, name: "task 1", taskScheduledDate: ConvertDate().convert(from: "2022-02-14"), notes: "nnnnnn", status: false),
                                        Task.init(id: 1, name: "task 2", taskScheduledDate: ConvertDate().convert(from: "2022-02-14"), notes: "nnnnnn", status: true)]))
        group.append(Group.init(
            id: 2, name: "Work", list: [Task.init(id: 2, name: "task 0", taskScheduledDate: ConvertDate().convert(from: "2022-02-09"), notes: "nnnnnn", status: true)]))
        group.append(Group.init(
            id: 3, name: "Hobby", list: [Task.init(id: 3, name: "task 0", taskScheduledDate: ConvertDate().convert(from: "2022-02-20"), notes: "nnnnnn", status: false),
                                         Task.init(id: 3, name: "task 1", taskScheduledDate: ConvertDate().convert(from: "2022-02-01"), notes: "nnnnnn", status: false),
                                         Task.init(id: 3, name: "task 2", taskScheduledDate: ConvertDate().convert(from: "2022-02-11"), notes: "nnnnnn", status: true),
                                         Task.init(id: 3, name: "task 3", taskScheduledDate: ConvertDate().convert(from: "2022-02-11"), notes: "nnnnnn", status: true),
                                         Task.init(id: 3, name: "task 4", taskScheduledDate: ConvertDate().convert(from: "2022-02-01"), notes: "nnnnnn", status: true),
                                         Task.init(id: 3, name: "task 5", taskScheduledDate: ConvertDate().convert(from: "2022-02-11"), notes: "nnnnnn", status: false)]))
        group.append(Group.init(
            id: 4, name: "Films", list: [Task.init(id: 4, name: "task 0", taskScheduledDate: ConvertDate().convert(from: "2022-02-20"), notes: "nnnnnn", status: true),
                                         Task.init(id: 4, name: "task 1", taskScheduledDate: ConvertDate().convert(from: "2022-02-11"), notes: "nnnnnn", status: true)]))
        group.append(Group.init(
            id: 5, name: "Building", list: [Task.init(id: 5, name: "task 0", taskScheduledDate: ConvertDate().convert(from: "2022-02-11"), notes: "nnnnnn", status: true),
                                            Task.init(id: 5, name: "task 1", taskScheduledDate: ConvertDate().convert(from: "2022-02-20"), notes: "nnnnnn", status: false)]))
    }
}
