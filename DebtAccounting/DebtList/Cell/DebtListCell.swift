import UIKit

protocol DebtListCellDelegate: AnyObject {
    func didButtonInCellTapped(_ cell: DebtListCell)
}

struct StateModelDebtListCell {
    var dateFormatter = DateService.shared
    var conversionRateService = ConversionRateService.shared
    
    var debt: Debt
    weak var delegate: DebtListCellDelegate?
    var isRub = true
    
    init(debt: Debt, delegate: DebtListCellDelegate, isRub: Bool) {
        self.debt = debt
        self.delegate = delegate
        self.isRub = isRub
    }
}

final class DebtListCell: UITableViewCell {
    static let reuseIdentifier = "DebtListCell"
    
    var stateModelDebtListCell: StateModelDebtListCell? {
        didSet {
            updateData()
        }
    }
    
    private let purshaseLabel = UILabel()
    private let nameLabel = UILabel()
    private let sumLabel = UILabel()
    private let stackView = UIStackView()
    private let button = UIButton()
    private let dateLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configurePurshaseLabel()
        configureNameLabel()
        configureSumLabel()
        configureStackView()
        configureButton()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configurePurshaseLabel() {
        purshaseLabel.font = UIFont.systemFont(ofSize: 17)
        purshaseLabel.textColor = UIColor(named: "YP Black")
        purshaseLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = UIColor(named: "YP Black")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSumLabel() {
        sumLabel.font = UIFont.systemFont(ofSize: 17)
        sumLabel.textColor = UIColor(named: "YP Black")
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.textColor = UIColor(named: "YP Black")
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(purshaseLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(sumLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureButton() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didButtonInCellTapped), for: .touchUpInside)
        button.tintColor = UIColor(named: "YP Black")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateData() {
        guard let stateModelDebtListCell else {return}
        let debt = stateModelDebtListCell.debt
        guard let purshase = debt.purshase else {return}
        guard let name = debt.name else {return}
        guard let date = debt.date else {return}
        
        purshaseLabel.text = "Покупка: \(purshase)"
        
        if debt.isI {
            nameLabel.text = "Кому: \(name)"
        } else {
            nameLabel.text = "Должник: \(name)"
        }
        
        if stateModelDebtListCell.isRub {
            sumLabel.text = "Сумма: \(debt.sum) руб"
        } else {
            guard let rate = stateModelDebtListCell.conversionRateService.conversionRate?.rate else {return}
            let dollars = Double(debt.sum) * rate
            let roundedNumber = Double(String(format: "%.2f", dollars))!
            sumLabel.text = "Сумма: \(roundedNumber) $"
        }
        
        if debt.isActive {
            button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        
        dateLabel.text = stateModelDebtListCell.dateFormatter.dayMonthAndYear(date: date)
    }
    
    @objc func didButtonInCellTapped() {
        stateModelDebtListCell?.delegate?.didButtonInCellTapped(self)
    }
}
