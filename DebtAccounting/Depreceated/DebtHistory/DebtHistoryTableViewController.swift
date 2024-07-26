//import UIKit
//
//final class DebtHistoryTableViewController: UIViewController {
//    
//    private let dateService = DateService.shared
//    private let sumProfile = SumProfile.shared
//    private let activeProfile = ActiveProfile.shared
//    private let historyProfile = HistoryProfile.shared
//    private let conversionRateService = ConversionRateService.shared
//    private let context = CoreDataService.shared.getContext()
//    
//    private let currencyBarButtonItem = UIBarButtonItem()
//    private let addBarButtonItem = UIBarButtonItem()
//    private let segmentedControl = UISegmentedControl()
//    private let tableView = UITableView(frame: .zero, style: .grouped)
//    private let tableHeaderView = UIView()
//    private let tittleTableLabel = UILabel()
//    
//    var currencyIsRub = true
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        configureNavigationItem()
//        configureSegmentedControl()
//        addObserver()
//        configureTableView()
//        configureTableHeaderView()
//        configureTittleTableLabel()
//        setConstraints()
//    }
//    
//    private func addObserver() {
//        
//        NotificationCenter.default.addObserver(forName: historyProfile.didChangeHistoryIToArr, object: nil, queue: .main) { [weak self] notification in
//            guard let self else {return}
//            self.tableView.reloadData()
//        }
//        
//        NotificationCenter.default.addObserver(forName: historyProfile.didChangeHistoryToMeArr, object: nil, queue: .main) { [weak self] notification in
//            guard let self else {return}
//            self.tableView.reloadData()
//        }
//    }
//    
//    private func configureNavigationItem() {
//        navigationItem.title = ""
//        guard let ypBlackColor = UIColor(named: "YP Black") else {return}
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ypBlackColor]
//        
//        navigationItem.leftBarButtonItem = currencyBarButtonItem
//        currencyBarButtonItem.image = UIImage(systemName: "rublesign")
//        currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
//        currencyBarButtonItem.target = self
//        currencyBarButtonItem.action = #selector(didCurrencyBarButtonTapped)
//    }
//    
//    private func configureSegmentedControl() {
//        view.addSubview(segmentedControl)
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        segmentedControl.insertSegment(withTitle: "Я должен", at: 0, animated: false)
//        segmentedControl.insertSegment(withTitle: "Мне должны", at: 1, animated: false)
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
//    }
//    
//    private func configureTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(DebtHistoryTableViewCell.self, forCellReuseIdentifier: DebtHistoryTableViewCell.reuseIdentifier)
//        tableView.rowHeight = 130
//        tableView.backgroundColor = .white
//        tableView.register(TableSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableSectionHeader.reuseIdentifier)
//    }
//    
//    private func configureTableHeaderView() {
//        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
//        tableView.tableHeaderView = tableHeaderView
//    }
//    
//    private func configureTittleTableLabel() {
//        tittleTableLabel.text = "История"
//        
//        tittleTableLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
//        tittleTableLabel.textColor = UIColor(named: "YP Black")
//        tableHeaderView.addSubview(tittleTableLabel)
//        tittleTableLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            tittleTableLabel.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 16),
//            tittleTableLabel.centerYAnchor.constraint(equalTo: tableHeaderView.centerYAnchor)
//        ])
//    }
//    
//    private func setConstraints() {
//        NSLayoutConstraint.activate([
//            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//        ])
//    }
//    
//    private func configureCell(cell: DebtHistoryTableViewCell, indexPath: IndexPath) {
//        cell.delegate = self
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let model = historyProfile.histIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            cell.model = model
//            cell.isRub = currencyIsRub
//            cell.setDataInCell()
//        } else {
//            guard let model = historyProfile.histToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            cell.model = model
//            cell.isRub = currencyIsRub
//            cell.setDataInCell()
//        }
//    }
//    
//    @objc private func segmentedControlDidChange() {
//        tableView.reloadData()
//    }
//}
//
////MARK: - DebtHistoryTableViewCellDelegate
//
//extension DebtHistoryTableViewController: DebtHistoryTableViewCellDelegate {
//    
//    func didBackButtonTapped(_ cell: DebtHistoryTableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else {return}
//        if segmentedControl.selectedSegmentIndex == 0 {
//            
//            guard let model = historyProfile.histIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            guard let modelDate = model.date else {return}
//            sumProfile.sumITo?.sum += model.sum
//            
//            let newModel = Model(context: context)
//            newModel.name = model.name
//            newModel.sum = model.sum
//            newModel.date = model.date
//            newModel.isToMe = false
//            newModel.purshase = model.purshase
//            newModel.isHist = false
//            newModel.phone = model.phone
//            newModel.telegram = model.telegram
//            
//            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: modelDate) {
//                activeProfile.activeIToArr[indexOfSection].addToModels(newModel)
//                
//                guard let sortedArr = activeProfile.activeIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                activeProfile.activeIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                let section = Section(context: context)
//                section.date = modelDate
//                section.isHist = false
//                section.isToMe = false
//                section.addToModels(newModel)
//                activeProfile.activeIToArr.append(section)
//                activeProfile.activeIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//            }
//            
//            guard let models = historyProfile.histIToArr[indexPath.section].models as? NSMutableOrderedSet else {return}
//            if models.count > 1 {
//                context.delete(model)
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else {
//                context.delete(historyProfile.histIToArr[indexPath.section])
//                
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                historyProfile.histIToArr.remove(at: indexPath.section)
//                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
//            }
//            
//            NotificationCenter.default.post(name: activeProfile.didChangeActiveIToArr, object: nil)
//            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
//        } else {
//            
//            guard let model = historyProfile.histToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            guard let modelDate = model.date else {return}
//            sumProfile.sumToMe?.sum += model.sum
//            
//            let newModel = Model(context: context)
//            newModel.name = model.name
//            newModel.sum = model.sum
//            newModel.date = model.date
//            newModel.isToMe = true
//            newModel.purshase = model.purshase
//            newModel.isHist = false
//            newModel.phone = model.phone
//            newModel.telegram = model.telegram
//            
//            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: modelDate) {
//                activeProfile.activeToMeArr[indexOfSection].addToModels(newModel)
//                
//                guard let sortedArr = activeProfile.activeToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                activeProfile.activeToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                let section = Section(context: context)
//                section.date = modelDate
//                section.isHist = false
//                section.isToMe = true
//                section.addToModels(newModel)
//                activeProfile.activeToMeArr.append(section)
//                activeProfile.activeToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//            }
//            
//            guard let models = historyProfile.histToMeArr[indexPath.section].models as? NSMutableOrderedSet else {return}
//            if models.count > 1 {
//                context.delete(model)
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else {
//                context.delete(historyProfile.histToMeArr[indexPath.section])
//                
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                historyProfile.histToMeArr.remove(at: indexPath.section)
//                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
//            }
//            
//            NotificationCenter.default.post(name: activeProfile.didChangeActiveToMeArr, object: nil)
//            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
//        }
//    }
//}
//
////MARK: - DidCurrencyBarButtonTapped
//
//extension DebtHistoryTableViewController {
//    @objc private func didCurrencyBarButtonTapped() {
//        if currencyIsRub {
//            currencyBarButtonItem.image = UIImage(systemName: "dollarsign")
//            currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
//            currencyIsRub = false
//            tableView.reloadData()
//        } else {
//            currencyBarButtonItem.image = UIImage(systemName: "rublesign")
//            currencyBarButtonItem.tintColor = UIColor(named: "YP Black")
//            currencyIsRub = true
//            tableView.reloadData()
//        }
//    }
//}
//
////MARK: - UITableViewDataSource
//
//extension DebtHistoryTableViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebtHistoryTableViewCell.reuseIdentifier, for: indexPath) as? DebtHistoryTableViewCell else {return UITableViewCell()}
//        configureCell(cell: cell, indexPath: indexPath)
//        return cell
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            historyProfile.histIToArr.count
//        } else {
//            historyProfile.histToMeArr.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let models = historyProfile.histIToArr[section].models else {return 0}
//            return models.count
//        } else {
//            guard let models = historyProfile.histToMeArr[section].models else {return 0}
//            return models.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        30
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeader.reuseIdentifier) as? TableSectionHeader else {fatalError("Header section")}
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let sectionDate = historyProfile.histIToArr[section].date else {return UIView()}
//            let text = dateService.monthAndYear(date: sectionDate)
//            headerView.setDataInHeader(text: text)
//        } else {
//            guard let sectionDate = historyProfile.histToMeArr[section].date else {return UIView()}
//            let text = dateService.monthAndYear(date: sectionDate)
//            headerView.setDataInHeader(text: text)
//        }
//        
//        return headerView
//    }
//}
//
////MARK: - UITableViewDelegate
//
//extension DebtHistoryTableViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dataVC = DataEditViewController()
//        dataVC.delegate = self
//        dataVC.indexPath = indexPath
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let model = historyProfile.histIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            dataVC.model = model
//        } else {
//            guard let model = historyProfile.histToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            dataVC.model = model
//        }
//        
//        dataVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(dataVC, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
////MARK: - DataEditViewControllerDelegate
//
//extension DebtHistoryTableViewController: DataEditViewControllerDelegate {
//    func didTapBackButton() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    func didTapEditSaveBarButton(indexPath: IndexPath, model: Model, firstModel: Model) {
//        navigationController?.popViewController(animated: true)
//        if segmentedControl.selectedSegmentIndex == 0 {
//            
//            if dateService.compareDatesIgnoringDay(model.date ?? Date(), historyProfile.histIToArr[indexPath.section].date ?? Date()) {
//                
//                guard let lastModel = historyProfile.histIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//                context.delete(lastModel)
//                historyProfile.histIToArr[indexPath.section].addToModels(model)
//                
//                guard let sortedArr = historyProfile.histIToArr[indexPath.section].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                historyProfile.histIToArr[indexPath.section].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                
//                guard let models = historyProfile.histIToArr[indexPath.section].models else {return}
//                if models.count > 1 {
//                    context.delete(firstModel)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date ?? Date()) {
//                        historyProfile.histIToArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = historyProfile.histIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        historyProfile.histIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = false
//                        section.addToModels(model)
//                        historyProfile.histIToArr.append(section)
//                        historyProfile.histIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                } else {
//                    context.delete(historyProfile.histIToArr[indexPath.section])
//                    
//                    historyProfile.histIToArr.remove(at: indexPath.section)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: model.date ?? Date()) {
//                        historyProfile.histIToArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = historyProfile.histIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        historyProfile.histIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = false
//                        section.addToModels(model)
//                        historyProfile.histIToArr.append(section)
//                        historyProfile.histIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                }
//            }
//
//        } else {
//            
//            if dateService.compareDatesIgnoringDay(model.date ?? Date(), historyProfile.histToMeArr[indexPath.section].date ?? Date()) {
//                
//                guard let lastModel = historyProfile.histToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//                context.delete(lastModel)
//                historyProfile.histToMeArr[indexPath.section].addToModels(model)
//                
//                guard let sortedArr = historyProfile.histToMeArr[indexPath.section].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                historyProfile.histToMeArr[indexPath.section].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                
//                guard let models = historyProfile.histToMeArr[indexPath.section].models else {return}
//                if models.count > 1 {
//                    context.delete(firstModel)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histToMeArr, withDate: model.date ?? Date()) {
//                        historyProfile.histToMeArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = historyProfile.histToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        historyProfile.histToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = true
//                        section.addToModels(model)
//                        historyProfile.histToMeArr.append(section)
//                        historyProfile.histToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                } else {
//                    context.delete(historyProfile.histToMeArr[indexPath.section])
//                    
//                    historyProfile.histToMeArr.remove(at: indexPath.section)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: historyProfile.histToMeArr, withDate: model.date ?? Date()) {
//                        historyProfile.histToMeArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = historyProfile.histToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        historyProfile.histToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = true
//                        section.addToModels(model)
//                        historyProfile.histToMeArr.append(section)
//                        historyProfile.histToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                }
//            }
//        }
//        
//        do {
//            try context.save()
//            tableView.reloadData()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}
//
////MARK: - ScrollViewDelegate
//
//extension DebtHistoryTableViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 60 {
//            navigationItem.title = "История"
//        } else {
//            navigationItem.title = ""
//        }
//    }
//}
