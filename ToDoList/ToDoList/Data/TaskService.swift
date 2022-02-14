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
    
    //Для View Controller Inbox
    func filterPeriod() -> [Group]?{
        
        var sections = [String]()
        var tasks =  [(Int, Task)]()
        var tasksByPeriods = [Group]()
        
        for g in 0..<group.count{
            if let countL = group[g].list?.count{
                for l in 0..<countL{
                    //Получить период до планируемой даты
                    var s = ConvertDate().IntervaleString(end: group[g].list?[l].taskScheduledDate)
                    if !sections.contains(s){
                        //Массив всех периодов
                        sections.append(s)
                    }
                    //Массив всех задач Id = section, Task = value
                    if  let task = group[g].list?[l],
                        let id = sections.index{$0 == s}{
                            tasks.append((id,task))
                    }
                }
            }
        }

        for s in 0..<sections.count{                 //Section
            var temp = [Task]()
            for t in 0..<tasks.count{                //Task
                if (s == tasks[t].0){
                    temp.append(tasks[t].1)
                }
            }
            tasksByPeriods.append(Group.init(id: s, name: sections[s], list: temp))
        }
        
        return tasksByPeriods
    }
}
