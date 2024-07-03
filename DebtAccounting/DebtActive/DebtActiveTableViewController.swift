import UIKit

final class DebtActiveTableViewController: UIViewController {
    
    private let dateService = DateService.shared
    private let sumProfile = SumProfile.shared
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
    
    private func configureNavigationItem() {
        navigationItem.title = ""
        guard let ypBlackColor = UIColor(named: "YP Black") else {return}
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ypBlackColor]
        
        navigationItem.leftBarButtonItem = currencyBarButtonItem
        currencyBarButtonItem.image = UIImage(systemName: "rublesign")
        currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        addBarButtonItem.image = UIImage(systemName: "plus")
        addBarButtonItem.tintColor = UIColor(named: "YP Black")
        addBarButtonItem.target = self
        addBarButtonItem.action = #selector(addBarButtonTapped)
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
        tableView.register(DebtActiveTableViewCell.self, forCellReuseIdentifier: DebtActiveTableViewCell.reuseIdentifier)
        tableView.rowHeight = 130
    }
    
    private func configureTableHeaderView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func configureTittleTableLabel() {
        tittleTableLabel.text = "Активные долги"
        
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    @objc private func addBarButtonTapped() {
        let dataVC = DataCreateViewController()
        dataVC.delegate = self
        if segmentedControl.selectedSegmentIndex == 0 {
            dataVC.isToMe = false
        } else {
            dataVC.isToMe = true
        }
        dataVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dataVC, animated: true)
    }
    
    @objc private func segmentedControlDidChange() {
        tableView.reloadData()
    }
}

//MARK: - Observer

extension DebtActiveTableViewController {
    private func addObserver() {
        
        NotificationCenter.default.addObserver(forName: activeProfile.didChangeActiveIToArr, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: activeProfile.didChangeActiveToMeArr, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.tableView.reloadData()
        }
    }
}

//MARK: - ConfigureTableViewCell

extension DebtActiveTableViewController {
    private func configureCell(cell: DebtActiveTableViewCell, indexPath: IndexPath) {
        cell.delegate = self
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.model = activeProfile.activeIToArr[indexPath.section].models[indexPath.row]
            cell.setDataInCell()
        } else {
            cell.model = activeProfile.activeToMeArr[indexPath.section].models[indexPath.row]
            cell.setDataInCell()
        }
    }
}

//MARK: - DebtActiveTableViewCellDelegate

extension DebtActiveTableViewController: DebtActiveTableViewCellDelegate {
    
    func didDoneButtonTapped(_ cell: DebtActiveTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        if segmentedControl.selectedSegmentIndex == 0 {
            var model = activeProfile.activeIToArr[indexPath.section].models[indexPath.row]
            sumProfile.sumITo -= model.sum
            model.isHist = true
            
            if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date) {
                historyProfile.histIToArr[indexOfSection].models.append(model)
                historyProfile.histIToArr[indexOfSection].models.sort { $0.date < $1.date }
            } else {
                historyProfile.histIToArr.append(Section(date: model.date, models: [model]))
                historyProfile.histIToArr.sort { $0.date < $1.date }
            }
            
            if activeProfile.activeIToArr[indexPath.section].models.count > 1 {
                activeProfile.activeIToArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                activeProfile.activeIToArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                activeProfile.activeIToArr.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            NotificationCenter.default.post(name: historyProfile.didChangeHistoryIToArr, object: nil)
            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
        } else {
            var model = activeProfile.activeToMeArr[indexPath.section].models[indexPath.row]
            sumProfile.sumToMe -= model.sum
            model.isHist = true
            
            if let indexOfSection = dateService.indexOfSection(in: historyProfile.histToMeArr, withDate: model.date) {
                historyProfile.histToMeArr[indexOfSection].models.append(model)
                historyProfile.histToMeArr[indexOfSection].models.sort { $0.date < $1.date }
            } else {
                historyProfile.histToMeArr.append(Section(date: model.date, models: [model]))
                historyProfile.histToMeArr.sort { $0.date < $1.date }
            }
            
            if activeProfile.activeToMeArr[indexPath.section].models.count > 1 {
                activeProfile.activeToMeArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                activeProfile.activeToMeArr[indexPath.section].models.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                activeProfile.activeToMeArr.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            NotificationCenter.default.post(name: historyProfile.didChangeHistoryToMeArr, object: nil)
            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
        }
    }
}

//MARK: - UITableViewDataSource

extension DebtActiveTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebtActiveTableViewCell.reuseIdentifier, for: indexPath) as? DebtActiveTableViewCell else {return UITableViewCell()}
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            activeProfile.activeIToArr.count
        } else {
            activeProfile.activeToMeArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return activeProfile.activeIToArr[section].models.count
        } else {
            return activeProfile.activeToMeArr[section].models.count
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0 {
            return dateService.monthAndYear(date: activeProfile.activeIToArr[section].date)
        } else {
            return dateService.monthAndYear(date: activeProfile.activeToMeArr[section].date)
        }
    }
}

//MARK: - UITableViewDelegate

extension DebtActiveTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataVC = DataEditViewController()
        dataVC.delegate = self
        dataVC.indexPath = indexPath
        
        if segmentedControl.selectedSegmentIndex == 0 {
            dataVC.model = activeProfile.activeIToArr[indexPath.section].models[indexPath.row]
        } else {
            dataVC.model = activeProfile.activeToMeArr[indexPath.section].models[indexPath.row]
        }
        dataVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dataVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - DataEditViewControllerDelegate

extension DebtActiveTableViewController: DataEditViewControllerDelegate {
    func didTapEditSaveBarButton(indexPath: IndexPath, model: Model, firstModel: Model) {
        navigationController?.popViewController(animated: true)
        if segmentedControl.selectedSegmentIndex == 0 {
            if dateService.compareDatesIgnoringDay(model.date, activeProfile.activeIToArr[indexPath.section].date) {
                activeProfile.activeIToArr[indexPath.section].models[indexPath.row] = model
                activeProfile.activeIToArr[indexPath.section].models.sort { $0.date < $1.date }
            } else {
                if activeProfile.activeIToArr[indexPath.section].models.count > 1 {
                    activeProfile.activeIToArr[indexPath.section].models.remove(at: indexPath.row)
                    
                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: model.date) {
                        activeProfile.activeIToArr[indexOfSection].models.append(model)
                        activeProfile.activeIToArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        activeProfile.activeIToArr.append(Section(date: model.date, models: [model]))
                        activeProfile.activeIToArr.sort { $0.date < $1.date }
                    }
                } else {
                    activeProfile.activeIToArr[indexPath.section].models.remove(at: indexPath.row)
                    activeProfile.activeIToArr.remove(at: indexPath.section)
                    
                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: model.date) {
                        activeProfile.activeIToArr[indexOfSection].models.append(model)
                        activeProfile.activeIToArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        activeProfile.activeIToArr.append(Section(date: model.date, models: [model]))
                        activeProfile.activeIToArr.sort { $0.date < $1.date }
                    }
                }
            }
            
            sumProfile.sumITo = sumProfile.sumITo - firstModel.sum + model.sum
            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
        } else {
            if dateService.compareDatesIgnoringDay(model.date, activeProfile.activeToMeArr[indexPath.section].date) {
                activeProfile.activeToMeArr[indexPath.section].models[indexPath.row] = model
                activeProfile.activeToMeArr[indexPath.section].models.sort { $0.date < $1.date }
            } else {
                if activeProfile.activeToMeArr[indexPath.section].models.count > 1 {
                    activeProfile.activeToMeArr[indexPath.section].models.remove(at: indexPath.row)
                    
                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: model.date) {
                        activeProfile.activeToMeArr[indexOfSection].models.append(model)
                        activeProfile.activeToMeArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        activeProfile.activeToMeArr.append(Section(date: model.date, models: [model]))
                        activeProfile.activeToMeArr.sort { $0.date < $1.date }
                    }
                } else {
                    activeProfile.activeToMeArr[indexPath.section].models.remove(at: indexPath.row)
                    activeProfile.activeToMeArr.remove(at: indexPath.section)
                    
                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: model.date) {
                        activeProfile.activeToMeArr[indexOfSection].models.append(model)
                        activeProfile.activeToMeArr[indexOfSection].models.sort { $0.date < $1.date }
                    } else {
                        activeProfile.activeToMeArr.append(Section(date: model.date, models: [model]))
                        activeProfile.activeToMeArr.sort { $0.date < $1.date }
                    }
                }
            }
            
            sumProfile.sumToMe = sumProfile.sumToMe - firstModel.sum + model.sum
            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
        }
        tableView.reloadData()
    }
}

//MARK: - DataCreateViewControllerDelegate

extension DebtActiveTableViewController: DataCreateViewControllerDelegate {
    func didTapCreateSaveBarButton(model: Model) {
        navigationController?.popViewController(animated: true)
        if segmentedControl.selectedSegmentIndex == 0 {
            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: model.date) {
                activeProfile.activeIToArr[indexOfSection].models.append(model)
                activeProfile.activeIToArr[indexOfSection].models.sort { $0.date < $1.date }
            } else {
                activeProfile.activeIToArr.append(Section(date: model.date, models: [model]))
                activeProfile.activeIToArr.sort { $0.date < $1.date }
            }
            sumProfile.sumITo += model.sum
            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
        } else {
            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: model.date) {
                activeProfile.activeToMeArr[indexOfSection].models.append(model)
                activeProfile.activeToMeArr[indexOfSection].models.sort { $0.date < $1.date }
            } else {
                activeProfile.activeToMeArr.append(Section(date: model.date, models: [model]))
                activeProfile.activeToMeArr.sort { $0.date < $1.date }
            }
            sumProfile.sumToMe += model.sum
            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
        }
        tableView.reloadData()
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - ContainsDate

extension DebtActiveTableViewController {
    
}
