import UIKit

class MainViewController: UIViewController {
    
    private let barButtonItem = UIBarButtonItem()
    private let segmentedControl = UISegmentedControl()
    private let sumLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationItem()
        configureSegmentedControl()
        configureSumLabel(sum: 1000, currencyIsRub: true)
        setConstraints()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Главная"
        navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.image = UIImage(systemName: "rublesign")
        barButtonItem.tintColor = UIColor(named: "YP Black")
    }
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Я должен", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Мне должны", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func configureSumLabel(sum: Int, currencyIsRub: Bool) {
        view.addSubview(sumLabel)
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
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
}

