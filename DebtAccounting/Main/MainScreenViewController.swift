import UIKit

//MARK: - Protocols

protocol MainScreenViewControllerInputProtocol: AnyObject {
    func updateSumLabel(text: String)
    func setImageForCurrencyButton(with systemName: String)
}

protocol MainScreenViewControllerOutputProtocol {
    init(view: MainScreenViewControllerInputProtocol)
    func viewDidLoad()
    func segmentedControlValueChanged()
    func didCurrencyBarButtonTapped()
}

//MARK: - MainScreenViewController

final class MainScreenViewController: UIViewController {
    private let currencyBarButtonItem = UIBarButtonItem()
    private let segmentedControl = UISegmentedControl()
    private let sumLabel = UILabel()
    
    var presenter: MainScreenViewControllerOutputProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        configureNavigationItem()
        configureSegmentedControl()
        configureSumLabel()
        setConstraints()
        presenter.viewDidLoad()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Главная"
        navigationItem.leftBarButtonItem = currencyBarButtonItem
        currencyBarButtonItem.image = UIImage(systemName: "rublesign")
        currencyBarButtonItem.tintColor = .text
        currencyBarButtonItem.target = self
        currencyBarButtonItem.action = #selector(didCurrencyBarButtonTapped)
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Я должен", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Мне должны", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func configureSumLabel() {
        view.addSubview(sumLabel)
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        sumLabel.textColor = .text
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sumLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func segmentedControlValueChanged() {
        presenter.segmentedControlValueChanged()
    }
    
    @objc private func didCurrencyBarButtonTapped() {
        presenter.didCurrencyBarButtonTapped()
    }
}

//MARK: - MainScreenViewControllerInputProtocol

extension MainScreenViewController: MainScreenViewControllerInputProtocol {
    func updateSumLabel(text: String) {
        sumLabel.text = text
    }
    
    func setImageForCurrencyButton(with systemName: String) {
        currencyBarButtonItem.image = UIImage(systemName: systemName)
    }
}




