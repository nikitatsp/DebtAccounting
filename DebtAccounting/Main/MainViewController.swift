import UIKit

final class MainViewController: UIViewController {
    
    private let model = SumProfile.shared
    private let barButtonItem = UIBarButtonItem()
    private let segmentedControl = UISegmentedControl()
    private let sumLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        configureNavigationItem()
        configureSegmentedControl()
        configureSumLabel(sum: model.sumITo, currencyIsRub: true)
        setConstraints()
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: model.didChangeSumITo, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.configureSumLabel(sum: self.model.sumITo, currencyIsRub: true)
            }
        }
        
        NotificationCenter.default.addObserver(forName: model.didChangeSumToMe, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            if segmentedControl.selectedSegmentIndex == 1 {
                self.configureSumLabel(sum: self.model.sumToMe, currencyIsRub: true)
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sumLabel)
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Главная"
        navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.image = UIImage(systemName: "rublesign")
        barButtonItem.tintColor = UIColor(named: "YP Black")
    }
    
    private func configureSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "Я должен", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Мне должны", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func configureSumLabel(sum: Int?, currencyIsRub: Bool) {
        guard let sum else {return}
        sumLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        sumLabel.textColor = UIColor(named: "YP Black")
        if currencyIsRub {
            sumLabel.text = "\(sum) руб"
        } else {
            sumLabel.text = "\(sum) $"
        }
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
        if segmentedControl.selectedSegmentIndex == 0 {
            configureSumLabel(sum: model.sumITo, currencyIsRub: true)
        } else {
            configureSumLabel(sum: model.sumToMe, currencyIsRub: true)
        }
    }
}

