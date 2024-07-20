import UIKit

protocol DebtListViewControllerInputProtocol: AnyObject {
    func setTittleForNavigationController(text: String)
    func setTextForTableViewHeader(text: String)
    func setImageForCurrencyButton(withSystemName name: String)
    func setImageForRightBarButton(withSystemName name: String)
    func reloadDataForTableView()
    func toogleEditTableView()
}

protocol DebtListViewControllerOutputProtocol {
    init(view: DebtListViewControllerInputProtocol, isActive: Bool)
    func viewDidLoad()
    func scrollViewDidScroll(_ contentOffset: CGPoint)
    func numberOfSections() -> Int
    func numberOfRowsInSection(at index: Int) -> Int
    func configureCell(_ cell: DebtListCell, with indexPath: IndexPath)
    func didCurrencyBarButtonTapped()
    func rightBarButtonTapped()
    func commitDeleteEdittingStyle(indexPath: IndexPath)
    func segmentedControlDidChange()
}

//MARK: - DebtListViewController

class DebtListViewController: UIViewController {
    var presenter: DebtListViewControllerOutputProtocol!
    
    private let currencyBarButtonItem = UIBarButtonItem()
    private let rightBarButtonItem = UIBarButtonItem()
    private let segmentedControl = UISegmentedControl()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableHeaderView = UIView()
    private let tittleTableLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureSegmentedControl()
        configureTableView()
        configureTableHeaderView()
        setConstraints()
        
        presenter.viewDidLoad()
    }
    
    private func configureNavigationItem() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.ypBlack]
        
        navigationItem.leftBarButtonItem = currencyBarButtonItem
        currencyBarButtonItem.image = UIImage(systemName: "rublesign")
        currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
        currencyBarButtonItem.target = self
        currencyBarButtonItem.action = #selector(didCurrencyBarButtonTapped)
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.tintColor = UIColor(named: "YP Black")
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(rightBarButtonTapped)
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
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DebtListCell.self, forCellReuseIdentifier: DebtListCell.reuseIdentifier)
        tableView.register(TableSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableSectionHeader.reuseIdentifier)
        tableView.rowHeight = 130
    }
    
    private func configureTableHeaderView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    @objc private func didCurrencyBarButtonTapped() {
        presenter.didCurrencyBarButtonTapped()
    }
    
    @objc private func rightBarButtonTapped() {
        presenter.rightBarButtonTapped()
    }
    
    @objc private func segmentedControlDidChange() {
        presenter.segmentedControlDidChange()
    }
}

//MARK: - DebtListViewControllerInputProtocol

extension DebtListViewController: DebtListViewControllerInputProtocol {
    func setTittleForNavigationController(text: String) {
        navigationItem.title = text
    }
    
    func setTextForTableViewHeader(text: String) {
        tittleTableLabel.text = text
    }
    
    func setImageForCurrencyButton(withSystemName name: String) {
        currencyBarButtonItem.image = UIImage(systemName: name)
    }
    
    func setImageForRightBarButton(withSystemName name: String) {
        rightBarButtonItem.image = UIImage(systemName: name)
    }
    
    func reloadDataForTableView() {
        tableView.reloadData()
    }
    
    func toogleEditTableView() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension DebtListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebtListCell.reuseIdentifier, for: indexPath) as? DebtListCell else {
            print("DebtListViewController/cellForRowAt: cell is nil")
            return UITableViewCell()
        }
        presenter.configureCell(cell, with: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension DebtListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.commitDeleteEdittingStyle(indexPath: indexPath)
        }
    }
}

//MARK: - UIScrollViewDelegate

extension DebtListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.scrollViewDidScroll(scrollView.contentOffset)
    }
}
