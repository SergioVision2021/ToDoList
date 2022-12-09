//  swiftlint:disable all
//  InBoxViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

enum Operations {
    case add
    case edit
    case delete
}

class InBoxViewController: UIViewController {

    // MARK: - Public properties
    public var service: TaskServiceLogic?
    public var router: InBoxRouter?

    // MARK: - Private properties
    private var repository = AppDI.makeTaskRepository()
    private var data: [Group] = []

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()
    private lazy var activitiIndicator = makeActivityIndicatorView()
    private lazy var alertController = makeAlertController(nil)

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        addTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetch()
    }
    
    private func fetch() {
        repository.fetch(force: false) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case.success(let dataModel):

                //TASK SERVICE
                self.service?.source = dataModel
                
                self.service?.fetch() { (result) in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.data = data
                            print(data)
                            self.tableView.reloadData()
                        }
                    case .failure(_):
                        break
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self.present(self.makeAlertController(error.localizedDescription), animated: true, completion: nil)
                }
            }
        }
    }
    
    private func execute(operation: Operations, _ task: Task) {

        repository.update(operation, task) { [weak self] error in
            guard let self = self else { return }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.present(self.makeAlertController(error?.localizedDescription), animated: true, completion: nil)
                }
                return
            }
            
            self.fetch()
        }
    }
}

// MARK: - TableView
private extension InBoxViewController {

    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func configureCell(_ cell: TaskCell, _ at: IndexPath) {
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let task = data[at.section].tasks?[at.row]
        if let name = task?.name,
           let status = task?.status {
            cell.statusImageView.tintColor = status ? .systemGreen : .systemYellow
            cell.nameLabel.text = name
        }
    }

    func configureSection(_ section: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        lbl.font = UIFont.boldSystemFont(ofSize: 18.0)
        lbl.text = data[section].name
        view.addSubview(lbl)
        return view
    }
}

// MARK: - TableView DataSource
extension InBoxViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        print("Coutn: \(data.count)")
        
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].tasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as? TaskCell else { fatalError("Unexpected Index Path") }

        configureCell(cell, indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            guard let selectTask = data[indexPath.section].tasks?[indexPath.row] else { return }

            data[indexPath.section].tasks?.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            
            execute(operation: .delete, selectTask)
        }
    }
}

// MARK: - TableView Delegate
extension InBoxViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureSection(section)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.navigationToDetailTask(task: data[indexPath.section].tasks?[indexPath.row] ?? Task(),
                                       nameSection: data[indexPath.section].name ?? "",
                                       repository: repository,
                                       sender: self)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: - BarButtonItem
private extension InBoxViewController {
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addActionButton(sender:)))
    }

    @objc
    func addActionButton(sender: UIBarButtonItem) {
        router?.navigationToAddTask(repository: repository)
    }
}

// MARK: - Factory
private extension InBoxViewController {
    func makeTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0

        let nib = UINib(nibName: "TaskCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.taskCellIdentifier)

        return table
    }
    
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView()
        ai.style = .large
        ai.center = view.center
        
        return ai
    }
    
    func makeAlertController(_ message: String?) -> UIAlertController {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(button)
        return ac
    }
}

//MARK: - ActivitiIndicator
private extension InBoxViewController {
    func startAnimationAI() {
        
        guard view.contains(activitiIndicator) else {
            view.addSubview(activitiIndicator)
            activitiIndicator.startAnimating()
            return
        }
    
        activitiIndicator.startAnimating()
    }
    
    func stopAnimationAI(_ result: String?) {
        DispatchQueue.main.async {
            self.activitiIndicator.stopAnimating()
            self.activitiIndicator.removeFromSuperview()
            
            guard let result = result else {
                return
            }
            
            self.present(self.makeAlertController(result), animated: true, completion: nil)
        }
    }
}
