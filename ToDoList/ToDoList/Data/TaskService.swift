//
//  TaskService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

class TaskService{
    var source = [Group]()

    var current = [Group]()
    
    init(){
        source.append(Group.init(
            id: 0, name: "Inbox", list: [Task.init(id: 0, name: "task 0", taskDeadline: ConvertDate().convert(from: "2022-02-15"), taskScheduledDate: ConvertDate().convert(from: "2022-02-15"), notes: "nnnnnn", status: true),
                                        Task.init(id: 0, name: "task 1", taskScheduledDate: ConvertDate().convert(from: "2022-02-17"), notes: "nnnnnn", status: false),
                                        Task.init(id: 0, name: "task 2", taskDeadline: ConvertDate().convert(from: "2022-02-14"), taskScheduledDate: ConvertDate().convert(from: "2022-02-14"), notes: "nnnnnn", status: true)]))
        source.append(Group.init(
            id: 1, name: "Hobby", list: [Task.init(id: 1, name: "Собрать кухню", taskScheduledDate: ConvertDate().convert(from: "2022-02-20"), notes: "Нет времени", status: false)]))
        source.append(Group.init(
            id: 2, name: "Work", list: [Task.init(id: 2, name: "Написать тестовое задание", taskScheduledDate: Date(), notes: "Самообразование", status: false),
                                         Task.init(id: 2, name: "Прочитать статьи по SwiftGen", taskScheduledDate: ConvertDate().convert(from: "2022-02-15"), notes: "nnnnnn", status: false),
                                         Task.init(id: 2, name: "Проверить задачи в JIRA", taskScheduledDate: ConvertDate().convert(from: "2022-02-15"), notes: "Смотреть и наши и чешские", status: false),
                                         Task.init(id: 2, name: "Проверить invite от AppleID", taskDeadline: Date() + 1, taskScheduledDate: Date(), notes: "На почте от  Cetelem", status: true),
                                         Task.init(id: 2, name: "Потренероваться в перекраске WL для банка", taskScheduledDate: ConvertDate().convert(from: "2022-02-01"), notes: "Придумай сам", status: false),
                                         Task.init(id: 2, name: "Почитать док по GPE", taskScheduledDate: ConvertDate().convert(from: "2022-02-19"), notes: "Лежат в папке", status: false)]))
        source.append(Group.init(
            id: 3, name: "Films", list: [Task.init(id: 3, name: "Посмотреть Матрицу 4",  taskDeadline: ConvertDate().convert(from: "2022-02-15"), taskScheduledDate: ConvertDate().convert(from: "2022-02-21"), notes: "Советовали", status: true),
                                         Task.init(id: 3, name: "Посмотреть Анчартед: На картах не значится", taskScheduledDate: ConvertDate().convert(from: "2022-02-18"), notes: "Советовали", status: false)]))
        source.append(Group.init(
            id: 4, name: "Building", list: [Task.init(id: 4, name: "task 0", taskScheduledDate: ConvertDate().convert(from: "2022-02-17"), notes: "nnnnnn", status: false),
                                            Task.init(id: 4, name: "task 1", taskScheduledDate: ConvertDate().convert(from: "2022-02-20"), notes: "nnnnnn", status: false)]))
    }
    
    //Для InBoxViewController
    func filterPeriod() -> [Group]?{
        current.removeAll()
        
        var sections = [String]()
        var tasks =  [(Int, Task)]()
        //var tasksByPeriods = [Group]()
        
        for g in 0..<source.count{
            if let countL = source[g].list?.count{
                for l in 0..<countL{
                    //Получить период до планируемой даты
                    var s = ConvertDate().IntervaleString(end: source[g].list?[l].taskScheduledDate)
                    if !sections.contains(s){
                        //Массив всех периодов
                        sections.append(s)
                    }
                    //Массив всех задач Id = section, Task = value
                    if  let task = source[g].list?[l],
                        let id = sections.index{$0 == s}{
                            tasks.append((id,task))
                    }
                }
            }
        }

        for s in 0..<sections.count{                 //Section
            var sectionTasks = [Task]()
            for t in 0..<tasks.count{                //Task
                if (s == tasks[t].0){
                    sectionTasks.append(tasks[t].1)
                }
            }
            current.append(Group.init(id: s, name: sections[s], list: sectionTasks))
        }
        
        return current
    }
    
    //Для TodayViewController
    func filterToday(namePeriod: String) -> [Group]?{
        var source = filterPeriod()
    
        guard let source = source else {
            return nil
        }

        //Из всех секций = периодов получаем секцию ToDay
        var sectionToDay = [Group]()
        
        for i in 0..<source.count {
            if (source[i].name == namePeriod){
                sectionToDay = [source[i]]
                break
            }
        }
        
        guard sectionToDay.count != 0 else {
            return nil
        }

        //Создаем 2е секции по статусу тасков из секции ToDay
        var statusToDay = [Group]()
        
        if let c = sectionToDay[0].list?.count{
            var taskCompleted = [Task]()
            var taskIncomplete = [Task]()
            for i in 0..<c{
                if let task = sectionToDay[0].list?[i]{
                    switch task.status{
                    case true: taskCompleted.append(task)
                    case false: taskIncomplete.append(task)
                    default: break
                    }
                }
            }
            statusToDay.append(Group.init(id: 0, name: "Completed", list: taskCompleted))
            statusToDay.append(Group.init(id: 1, name: "Incomplete", list: taskIncomplete))
        }
        
        return statusToDay
    }
    
    
    func filterAllTasks() -> [String]{
        var allName = [String]()
        
        for g in 0..<source.count{
            if let countL = source[g].list?.count{
                for l in 0..<countL{
                    allName.append(source[g].list?[l].name ?? "")
                }
            }
        }
        
        return allName
    }
    
    func filterGroup() -> [String]{
        return source.map{str in str.name ?? ""}
    }
    
    //AddTask - добавление новой задачи
    func appendTask(newTask: [Group]){
        if  let list = newTask[0].list{
            source[0].list?.append(contentsOf: list)
        }
    }
    
    //DetailTask - авершение задачи
    func editTask(_ editTask: Task){
        let idGroup = editTask.id ?? 0
        let count = source[idGroup].list?.count ?? 0
        
        for i in 0..<count{
            if source[idGroup].list?[i].name == editTask.name{
                source[idGroup].list?[i].taskDeadline = Date()
                source[idGroup].list?[i].status = true
                break
            }
        }
    }
}
