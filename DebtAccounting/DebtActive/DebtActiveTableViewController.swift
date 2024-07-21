//import UIKit
//import CoreData
//
//final class DebtActiveTableViewController: UIViewController {
//    
//    private let dateService = DateService.shared
//    private let sumProfile = SumProfile.shared
//    private let activeProfile = ActiveProfile.shared
//    private let historyProfile = HistoryProfile.shared
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
//        
//        navigationItem.rightBarButtonItem = addBarButtonItem
//        addBarButtonItem.image = UIImage(systemName: "plus")
//        addBarButtonItem.tintColor = UIColor(named: "YP Black")
//        addBarButtonItem.target = self
//        addBarButtonItem.action = #selector(addBarButtonTapped)
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
//        tableView.backgroundColor = .white
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(DebtActiveTableViewCell.self, forCellReuseIdentifier: DebtActiveTableViewCell.reuseIdentifier)
//        tableView.register(TableSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableSectionHeader.reuseIdentifier)
//        tableView.rowHeight = 130
//    }
//    
//    private func configureTableHeaderView() {
//        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
//        tableView.tableHeaderView = tableHeaderView
//    }
//    
//    private func configureTittleTableLabel() {
//        tittleTableLabel.text = "Активные долги"
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
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//        ])
//    }
//    
//    @objc private func addBarButtonTapped() {
//        let dataVC = DataCreateViewController()
//        dataVC.delegate = self
//        if segmentedControl.selectedSegmentIndex == 0 {
//            dataVC.isToMe = false
//        } else {
//            dataVC.isToMe = true
//        }
//        dataVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(dataVC, animated: true)
//    }
//    
//    @objc private func segmentedControlDidChange() {
//        tableView.reloadData()
//    }
//}
//
////MARK: - DidCurrencyBarButtonTapped
//
//extension DebtActiveTableViewController {
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
////MARK: - Observer
//
//extension DebtActiveTableViewController {
//    private func addObserver() {
//        
//        NotificationCenter.default.addObserver(forName: activeProfile.didChangeActiveIToArr, object: nil, queue: .main) { [weak self] notification in
//            guard let self else {return}
//            self.tableView.reloadData()
//        }
//        
//        NotificationCenter.default.addObserver(forName: activeProfile.didChangeActiveToMeArr, object: nil, queue: .main) { [weak self] notification in
//            guard let self else {return}
//            self.tableView.reloadData()
//        }
//    }
//}
//
////MARK: - ConfigureTableViewCell
//
//extension DebtActiveTableViewController {
//    private func configureCell(cell: DebtActiveTableViewCell, indexPath: IndexPath) {
//        cell.delegate = self
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let model = activeProfile.activeIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            cell.model = model
//            cell.isRub = currencyIsRub
//            cell.setDataInCell()
//        } else {
//            guard let model = activeProfile.activeToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            cell.model = model
//            cell.isRub = currencyIsRub
//            cell.setDataInCell()
//        }
//    }
//}
//
////MARK: - DebtActiveTableViewCellDelegate
//
//extension DebtActiveTableViewController: DebtActiveTableViewCellDelegate {
//    
//    func didDoneButtonTapped(_ cell: DebtActiveTableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else {return}
//        if segmentedControl.selectedSegmentIndex == 0 {
//            
//            guard let model = activeProfile.activeIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            guard let modelDate = model.date else {return}
//            sumProfile.sumITo?.sum -= model.sum
//            
//            let newModel = Model(context: context)
//            newModel.name = model.name
//            newModel.sum = model.sum
//            newModel.date = model.date
//            newModel.isToMe = model.isToMe
//            newModel.purshase = model.purshase
//            newModel.isHist = true
//            newModel.phone = model.phone
//            newModel.telegram = model.telegram
//            
//            if let indexOfSection = dateService.indexOfSection(in: historyProfile.histIToArr, withDate: modelDate) {
//                historyProfile.histIToArr[indexOfSection].addToModels(newModel)
//                
//                guard let sortedArr = historyProfile.histIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                historyProfile.histIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                let section = Section(context: context)
//                section.date = modelDate
//                section.isHist = true
//                section.isToMe = false
//                section.addToModels(newModel)
//                historyProfile.histIToArr.append(section)
//                historyProfile.histIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//            }
//            
//            guard let models = activeProfile.activeIToArr[indexPath.section].models as? NSMutableOrderedSet else {return}
//            if models.count > 1 {
//                context.delete(model)
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else {
//                context.delete(activeProfile.activeIToArr[indexPath.section])
//                
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                activeProfile.activeIToArr.remove(at: indexPath.section)
//                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
//            }
//            
//            NotificationCenter.default.post(name: historyProfile.didChangeHistoryIToArr, object: nil)
//            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
//        } else {
//            
//            guard let model = activeProfile.activeToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            guard let modelDate = model.date else {return}
//            sumProfile.sumToMe?.sum -= model.sum
//            
//            let newModel = Model(context: context)
//            newModel.name = model.name
//            newModel.sum = model.sum
//            newModel.date = model.date
//            newModel.isToMe = true
//            newModel.purshase = model.purshase
//            newModel.isHist = true
//            newModel.phone = model.phone
//            newModel.telegram = model.telegram
//            
//            if let indexOfSection = dateService.indexOfSection(in: historyProfile.histToMeArr, withDate: modelDate) {
//                historyProfile.histToMeArr[indexOfSection].addToModels(newModel)
//                
//                guard let sortedArr = historyProfile.histToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                historyProfile.histToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                let section = Section(context: context)
//                section.date = modelDate
//                section.isHist = true
//                section.isToMe = true
//                section.addToModels(newModel)
//                historyProfile.histToMeArr.append(section)
//                historyProfile.histToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//            
//            }
//            
//            guard let models = activeProfile.activeToMeArr[indexPath.section].models as? NSMutableOrderedSet else {return}
//            if models.count > 1 {
//                context.delete(model)
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else {
//                context.delete(activeProfile.activeToMeArr[indexPath.section])
//                
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                activeProfile.activeToMeArr.remove(at: indexPath.section)
//                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
//            }
//            
//            NotificationCenter.default.post(name: historyProfile.didChangeHistoryToMeArr, object: nil)
//            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
//        }
//    }
//}
//
////MARK: - UITableViewDataSource
//
//extension DebtActiveTableViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebtActiveTableViewCell.reuseIdentifier, for: indexPath) as? DebtActiveTableViewCell else {return UITableViewCell()}
//        configureCell(cell: cell, indexPath: indexPath)
//        return cell
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            activeProfile.activeIToArr.count
//        } else {
//            activeProfile.activeToMeArr.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let models = activeProfile.activeIToArr[section].models else {return 0}
//            return models.count
//        } else {
//            guard let models = activeProfile.activeToMeArr[section].models else {return 0}
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
//            guard let sectionDate = activeProfile.activeIToArr[section].date else {return UIView()}
//            let text = dateService.monthAndYear(date: sectionDate)
//            headerView.setDataInHeader(text: text)
//        } else {
//            guard let sectionDate = activeProfile.activeToMeArr[section].date else {return UIView()}
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
//extension DebtActiveTableViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dataVC = DataEditViewController()
//        dataVC.delegate = self
//        dataVC.indexPath = indexPath
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let model = activeProfile.activeIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            dataVC.model = model
//        } else {
//            guard let model = activeProfile.activeToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//            dataVC.model = model
//        }
//        dataVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(dataVC, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
////MARK: - DataEditViewControllerDelegate
//
//extension DebtActiveTableViewController: DataEditViewControllerDelegate {
//    func didTapEditSaveBarButton(indexPath: IndexPath, model: Model, firstModel: Model) {
//        navigationController?.popViewController(animated: true)
//        if segmentedControl.selectedSegmentIndex == 0 {
//            
//            if dateService.compareDatesIgnoringDay(model.date ?? Date(), activeProfile.activeIToArr[indexPath.section].date ?? Date()) {
//                
//                guard let lastModel = activeProfile.activeIToArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//                context.delete(lastModel)
//                activeProfile.activeIToArr[indexPath.section].addToModels(model)
//                
//                guard let sortedArr = activeProfile.activeIToArr[indexPath.section].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                activeProfile.activeIToArr[indexPath.section].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                
//                guard let models = activeProfile.activeIToArr[indexPath.section].models else {return}
//                if models.count > 1 {
//                    context.delete(firstModel)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: model.date ?? Date()) {
//                        activeProfile.activeIToArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = activeProfile.activeIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        activeProfile.activeIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = false
//                        section.addToModels(model)
//                        activeProfile.activeIToArr.append(section)
//                        activeProfile.activeIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                } else {
//                    context.delete(activeProfile.activeIToArr[indexPath.section])
//                    
//                    activeProfile.activeIToArr.remove(at: indexPath.section)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: model.date ?? Date()) {
//                        activeProfile.activeIToArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = activeProfile.activeIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        activeProfile.activeIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = false
//                        section.addToModels(model)
//                        activeProfile.activeIToArr.append(section)
//                        activeProfile.activeIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                }
//            }
//            
//            sumProfile.sumITo?.sum = (sumProfile.sumITo?.sum ?? 0) - firstModel.sum + model.sum
//            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
//        } else {
//            
//            if dateService.compareDatesIgnoringDay(model.date ?? Date(), activeProfile.activeToMeArr[indexPath.section].date ?? Date()) {
//                
//                guard let lastModel = activeProfile.activeToMeArr[indexPath.section].models?[indexPath.row] as? Model else {return}
//                context.delete(lastModel)
//                activeProfile.activeToMeArr[indexPath.section].addToModels(model)
//                
//                guard let sortedArr = activeProfile.activeToMeArr[indexPath.section].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                activeProfile.activeToMeArr[indexPath.section].models = NSOrderedSet(array: sortedArr)
//                
//            } else {
//                
//                guard let models = activeProfile.activeToMeArr[indexPath.section].models else {return}
//                if models.count > 1 {
//                    context.delete(firstModel)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: model.date ?? Date()) {
//                        activeProfile.activeToMeArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = activeProfile.activeToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        activeProfile.activeToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = true
//                        section.addToModels(model)
//                        activeProfile.activeToMeArr.append(section)
//                        activeProfile.activeToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                } else {
//                    context.delete(activeProfile.activeToMeArr[indexPath.section])
//                    
//                    activeProfile.activeToMeArr.remove(at: indexPath.section)
//                    
//                    if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: model.date ?? Date()) {
//                        activeProfile.activeToMeArr[indexOfSection].addToModels(model)
//                        
//                        guard let sortedArr = activeProfile.activeToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                        activeProfile.activeToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//                    } else {
//                        let section = Section(context: context)
//                        section.date = model.date
//                        section.isHist = model.isHist
//                        section.isToMe = true
//                        section.addToModels(model)
//                        activeProfile.activeToMeArr.append(section)
//                        activeProfile.activeToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//                    }
//                }
//            }
//            
//            sumProfile.sumToMe?.sum = (sumProfile.sumToMe?.sum ?? 0) - firstModel.sum + model.sum
//            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
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
////MARK: - DataCreateViewControllerDelegate
//
//extension DebtActiveTableViewController: DataCreateViewControllerDelegate {
//    func didTapCreateSaveBarButton(model: Model) {
//        guard let modelDate = model.date else {return}
//        navigationController?.popViewController(animated: true)
//        if segmentedControl.selectedSegmentIndex == 0 {
//            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeIToArr, withDate: modelDate) {
//                activeProfile.activeIToArr[indexOfSection].addToModels(model)
//                
//                guard let sortedArr = activeProfile.activeIToArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                activeProfile.activeIToArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//            } else {
//                let section = Section(context: context)
//                section.date = modelDate
//                section.isHist = false
//                section.isToMe = false
//                section.addToModels(model)
//                activeProfile.activeIToArr.append(section)
//                
//                activeProfile.activeIToArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//            }
//            
//            guard var sumITo = sumProfile.sumITo?.sum else {return}
//            sumITo += model.sum
//            sumProfile.sumITo?.sum = sumITo
//            NotificationCenter.default.post(name: sumProfile.didChangeSumITo, object: nil)
//        } else {
//            if let indexOfSection = dateService.indexOfSection(in: activeProfile.activeToMeArr, withDate: modelDate) {
//                activeProfile.activeToMeArr[indexOfSection].addToModels(model)
//                
//                guard let sortedArr = activeProfile.activeToMeArr[indexOfSection].models?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                activeProfile.activeToMeArr[indexOfSection].models = NSOrderedSet(array: sortedArr)
//            } else {
//                let section = Section(context: context)
//                section.date = modelDate
//                section.isHist = false
//                section.isToMe = true
//                section.addToModels(model)
//                activeProfile.activeToMeArr.append(section)
//                
//                activeProfile.activeToMeArr.sort { $0.date ?? Date() < $1.date ?? Date() }
//            }
//            
//            guard var sumToMe = sumProfile.sumToMe?.sum else {return}
//            sumToMe += model.sum
//            sumProfile.sumToMe?.sum = sumToMe
//            NotificationCenter.default.post(name: sumProfile.didChangeSumToMe, object: nil)
//        }
//        do {
//            try context.save()
//            tableView.reloadData()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func didTapBackButton() {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
////MARK: - ScrollViewDelegate
//
//extension DebtActiveTableViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 60 {
//            navigationItem.title = "Активные долги"
//        } else {
//            navigationItem.title = ""
//        }
//    }
//}
