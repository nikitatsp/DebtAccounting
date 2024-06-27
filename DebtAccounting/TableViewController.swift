import UIKit

final class TableViewController: UIViewController {
    
    var tittle: String?
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
        configureTableView()
        configureTableHeaderView()
        configureTittleTableLabel()
        setConstraints()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = ""
        guard let ypBlackColor = UIColor(named: "YP Black") else {return}
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ypBlackColor]
        navigationItem.leftBarButtonItem = currencyBarButtonItem
        navigationItem.rightBarButtonItem = addBarButtonItem
        currencyBarButtonItem.image = UIImage(systemName: "rublesign")
        currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
        addBarButtonItem.image = UIImage(systemName: "plus")
        addBarButtonItem.tintColor = UIColor(named: "YP Black")
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Я должен", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Мне должны", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.rowHeight = 100
    }
    
    private func configureTableHeaderView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func configureTittleTableLabel() {
        guard let tittle else {return}
        tittleTableLabel.text = tittle
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
    
    private func configureCell(cell: TableViewCell) {
        cell.sumLabel.text = "1000 руб"
        cell.nameLabel.text = "Мама"
        
        if tittle == "История" {
            cell.addBackButton()
        } else {
            cell.addDoneButton()
        }
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {return UITableViewCell()}
        configureCell(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
}

extension TableViewController: UITableViewDelegate {
    
}
