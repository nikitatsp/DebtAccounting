import UIKit

final class DebtHistoryTableViewController: UIViewController {
    
    private let activeProfile = ActiveProfile.shared
    private let historyProfile = HistoryProfile.shared
    
    private let currencyBarButtonItem = UIBarButtonItem()
    private let addBarButtonItem = UIBarButtonItem()
    private let segmentedControl = UISegmentedControl()
    private let tableView = UITableView()
    private let tableHeaderView = UIView()
    private let tittleTableLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationItem()
        configureSegmentedControl()
        addObserver()
        configureTableView()
        configureTableHeaderView()
        configureTittleTableLabel()
        setConstraints()
    }
    
    private func addObserver() {
        
        NotificationCenter.default.addObserver(forName: historyProfile.didChangeHistoryIToArr, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: historyProfile.didChangeHistoryToMeArr, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.tableView.reloadData()
        }
    }
    
    private func configureNavigationItem() {
        navigationItem.title = ""
        guard let ypBlackColor = UIColor(named: "YP Black") else {return}
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ypBlackColor]
        
        navigationItem.leftBarButtonItem = currencyBarButtonItem
        currencyBarButtonItem.image = UIImage(systemName: "rublesign")
        currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Я должен", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Мне должны", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DebtHistoryTableViewCell.self, forCellReuseIdentifier: DebtHistoryTableViewCell.reuseIdentifier)
        tableView.rowHeight = 100
    }
    
    private func configureTableHeaderView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func configureTittleTableLabel() {
        tittleTableLabel.text = "История"
        
        tittleTableLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        tittleTableLabel.textColor = UIColor(named: "YP Black")
        tableHeaderView.addSubview(tittleTableLabel)
        tittleTableLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tittleTableLabel.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 16),
            tittleTableLabel.centerYAnchor.constraint(equalTo: tableHeaderView.centerYAnchor)
        ])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    private func configureCell(cell: DebtHistoryTableViewCell, indexPath: IndexPath) {
        cell.delegate = self
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.nameLabel.text = historyProfile.histIToArr[indexPath.row].name
            cell.sumLabel.text = "\(historyProfile.histIToArr[indexPath.row].sum)"
        } else {
            cell.nameLabel.text = historyProfile.histToMeArr[indexPath.row].name
            cell.sumLabel.text = "\(historyProfile.histToMeArr[indexPath.row].sum)"
        }
    }
    
    @objc private func segmentedControlDidChange() {
        tableView.reloadData()
    }
}

//MARK: - DebtHistoryTableViewCellDelegate

extension DebtHistoryTableViewController: DebtHistoryTableViewCellDelegate {
    
    func didBackButtonTapped(_ cell: DebtHistoryTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        if segmentedControl.selectedSegmentIndex == 0 {
            activeProfile.activeIToArr.append(historyProfile.histIToArr[indexPath.row])
            historyProfile.histIToArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: activeProfile.didChangeActiveIToArr, object: nil)
        } else {
            activeProfile.activeToMeArr.append(historyProfile.histToMeArr[indexPath.row])
            historyProfile.histToMeArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: activeProfile.didChangeActiveToMeArr, object: nil)
        }
    }
}

//MARK: - UITableViewDataSource

extension DebtHistoryTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebtHistoryTableViewCell.reuseIdentifier, for: indexPath) as? DebtHistoryTableViewCell else {return UITableViewCell()}
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return historyProfile.histIToArr.count
        } else {
            return historyProfile.histToMeArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - UITableViewDelegate

extension DebtHistoryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

