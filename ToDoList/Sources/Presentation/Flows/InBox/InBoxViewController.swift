//  swiftlint:disable all
//  InBoxViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

protocol InBoxViewLogic: ViewProtocol {
    func display(vieModel: [Model.ViewModel.Group])
    func displayError(message: String)
}

class InBoxViewController: UIViewController, InBoxViewLogic {

    // MARK: - Public properties
    public var router: InBoxRouter?
    public var interactor: InBoxInteractorLogic?

    // MARK: - Private properties
    private var data: [Model.ViewModel.Group] = []

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()
    private lazy var activitiIndicator = makeActivityIndicatorView()
    private lazy var alertController = makeAlertController(nil)

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        addTableView()
        addActivitiIndicator()
        
        activitiIndicator.startAnimating()
        interactor?.fetchTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activitiIndicator.startAnimating()
        interactor?.fetchTasks()
    }

    func display(vieModel: [Model.ViewModel.Group]) {
        data = vieModel
        activitiIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func displayError(message: String) {
        activitiIndicator.stopAnimating()
        present(self.makeAlertController(message), animated: true, completion: nil)
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
        
        print("Count: \(data.count)")
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

            guard let id = data[indexPath.section].tasks?[indexPath.row].id else { return }

            data[indexPath.section].tasks?.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            
            interactor?.execute(id, operation: .delete)
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
        guard let id = data[indexPath.section].tasks?[indexPath.row].id else { return }
        router?.navigationToDetailTask(id: id, sender: self)
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
        router?.navigationToAddTask()
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
    
    func addActivitiIndicator() {
        view.addSubview(activitiIndicator)
    }
}
