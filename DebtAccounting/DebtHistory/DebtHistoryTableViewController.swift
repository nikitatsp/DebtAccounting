import UIKit

final class DebtHistoryTableViewController: UIViewController {
    
    private let dateService = DateService.shared
    private let sumProfile = SumProfile.shared
    private let activeProfile = ActiveProfile.shared
    private let historyProfile = HistoryProfile.shared
    private let conversionRateService = ConversionRateService.shared
    
    private let currencyBarButtonItem = UIBarButtonItem()
    private let addBarButtonItem = UIBarButtonItem()
    private let segmentedControl = UISegmentedControl()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableHeaderView = UIView()
    private let tittleTableLabel = UILabel()
    
    var currencyIsRub = true
    
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
        currencyBarButtonItem.target = self
        currencyBarButtonItem.action = #selector(didCurrencyBarButtonTapped)
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
        tableView.rowHeight = 130
        tableView.backgroundColor = .white
        tableView.register(TableSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableSectionHeader.reuseIdentifier)
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
            cell.model = historyProfile.histIToArr[indexPath.section].models[indexPath.row]
            cell.isRub = currencyIsRub
            cell.setDataInCell()
        } else {
            cell.model = historyProfile.histToMeArr[indexPath.section].models[indexPath.row]
            cell.isRub = currencyIsRub
            cell.setDataInCell()
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
            var model = historyProfile.histIToArr[indexPath.section].models[indexPath.row]
            sumProfile.sumITo += model.sum
            model.isHist = false
            
            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: model.date) {
                activeProfile.activeIToArr[indexOfSection].models.append(model)
                activeProfile.activeIToArr[indexOfSection].models.sort { $0.date < $1.date }
            } else {
                activeProfile.activeIToArr.append(Section(date: model.date, models: [model]))
                activeProfile.activeIToArr.sort { $0.date < $1.date }
            }
            
            if historyProfile.histIToArr[indexPath.section].models.count > 1 {
                historyProfile.histIToArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                historyProfile.histIToArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                historyProfile.histIToArr.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            NotificationCenter.default.post(name: activeProfile.didChangeActiveIToArr, object: nil)
            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
        } else {
            var model = historyProfile.histToMeArr[indexPath.section].models[indexPath.row]
            sumProfile.sumToMe += model.sum
            model.isHist = false
            
            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: model.date) {
                activeProfile.activeToMeArr[indexOfSection].models.append(model)
                activeProfile.activeToMeArr[indexOfSection].models.sort { $0.date < $1.date }
            } else {
                activeProfile.activeToMeArr.append(Section(date: model.date, models: [model]))
                activeProfile.activeToMeArr.sort { $0.date < $1.date }
            }
            
            if historyProfile.histToMeArr[indexPath.section].models.count > 1 {
                historyProfile.histToMeArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                historyProfile.histToMeArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                historyProfile.histToMeArr.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            NotificationCenter.default.post(name: activeProfile.didChangeActiveToMeArr, object: nil)
            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
        }
    }
}

//MARK: - DidCurrencyBarButtonTapped

extension DebtHistoryTableViewController {
    @objc private func didCurrencyBarButtonTapped() {
        if currencyIsRub {
            currencyBarButtonItem.image = UIImage(systemName: "dollarsign")
            currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
            currencyIsRub = false
            tableView.reloadData()
        } else {
            currencyBarButtonItem.image = UIImage(systemName: "rublesign")
            currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
            currencyIsRub = true
            tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            historyProfile.histIToArr.count
        } else {
            historyProfile.histToMeArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return historyProfile.histIToArr[section].models.count
        } else {
            return historyProfile.histToMeArr[section].models.count
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeader.reuseIdentifier) as? TableSectionHeader else {fatalError("Header section")}
        if segmentedControl.selectedSegmentIndex == 0 {
            let text = dateService.monthAndYear(date: historyProfile.histIToArr[section].date)
            headerView.setDataInHeader(text: text)
        } else {
            let text = dateService.monthAndYear(date: historyProfile.histToMeArr[section].date)
            headerView.setDataInHeader(text: text)
        }
        
        return headerView
    }
}

//MARK: - UITableViewDelegate

extension DebtHistoryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataVC = DataEditViewController()
        dataVC.delegate = self
        dataVC.indexPath = indexPath
        
        if segmentedControl.selectedSegmentIndex == 0 {
            dataVC.model = historyProfile.histIToArr[indexPath.section].models[indexPath.row]
        } else {
            dataVC.model = historyProfile.histToMeArr[indexPath.section].models[indexPath.row]
        }
        
        dataVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dataVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DebtHistoryTableViewController: DataEditViewControllerDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapEditSaveBarButton(indexPath: IndexPath, model: Model, firstModel: Model) {
        navigationController?.popViewController(animated: true)
        if segmentedControl.selectedSegmentIndex == 0 {
            if dateService.compareDatesIgnoringDay(model.date, historyProfile.histIToArr[indexPath.section].date) {
                historyProfile.histIToArr[indexPath.section].models[indexPath.row] = model
                historyProfile.histIToArr[indexPath.section].models.sort { $0.date < $1.date }
            } else {
                if historyProfile.histIToArr[indexPath.section].models.count > 1 {
                    historyProfile.histIToArr[indexPath.section].models.remove(at: indexPath.row)
                    
                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date) {
                        historyProfile.histIToArr[indexOfSection].models.append(model)
                        historyProfile.histIToArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        historyProfile.histIToArr.append(Section(date: model.date, models: [model]))
                        historyProfile.histIToArr.sort { $0.date < $1.date }
                    }
                } else {
                    historyProfile.histIToArr[indexPath.section].models.remove(at: indexPath.row)
                    historyProfile.histIToArr.remove(at: indexPath.section)
                    
                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date) {
                        historyProfile.histIToArr[indexOfSection].models.append(model)
                        historyProfile.histIToArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        historyProfile.histIToArr.append(Section(date: model.date, models: [model]))
                        historyProfile.histIToArr.sort { $0.date < $1.date }
                    }
                }
            }
            
        } else {
            if dateService.compareDatesIgnoringDay(model.date, historyProfile.histToMeArr[indexPath.section].date) {
                historyProfile.histIToArr[indexPath.section].models[indexPath.row] = model
                historyProfile.histIToArr[indexPath.section].models.sort { $0.date < $1.date }
            } else {
                if historyProfile.histIToArr[indexPath.section].models.count > 1 {
                    historyProfile.histIToArr[indexPath.section].models.remove(at: indexPath.row)
                    
                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date) {
                        historyProfile.histIToArr[indexOfSection].models.append(model)
                        historyProfile.histIToArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        historyProfile.histIToArr.append(Section(date: model.date, models: [model]))
                        historyProfile.histIToArr.sort { $0.date < $1.date }
                    }
                } else {
                    historyProfile.histIToArr[indexPath.section].models.remove(at: indexPath.row)
                    historyProfile.histIToArr.remove(at: indexPath.section)
                    
                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date) {
                        historyProfile.histIToArr[indexOfSection].models.append(model)
                        historyProfile.histIToArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        historyProfile.histIToArr.append(Section(date: model.date, models: [model]))
                        historyProfile.histIToArr.sort { $0.date < $1.date }
                    }
                }
            }
            
        }
        tableView.reloadData()
    }
}

//MARK: - ScrollViewDelegate

extension DebtHistoryTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 60 {
            navigationItem.title = "История"
        } else {
            navigationItem.title = ""
        }
    }
}
