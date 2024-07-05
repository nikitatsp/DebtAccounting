import UIKit

protocol DebtActiveTableViewCellDelegate: AnyObject {
    func didDoneButtonTapped(_ cell: DebtActiveTableViewCell)
}

class DebtActiveTableViewCell: UITableViewCell {
    static let reuseIdentifier = "Activecell"
    
    let dateFormatter = DateService.shared
    private let conversionRateService = ConversionRateService.shared
    
    var model: Model?
    weak var delegate: DebtActiveTableViewCellDelegate?
    var isITo = true
    var isRub = true
    
    private let purshaseLabel = UILabel()
    private let nameLabel = UILabel()
    private let sumLabel = UILabel()
    private let stackView = UIStackView()
    private let doneButton = UIButton()
    private let dateLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configurePurshaseLabel()
        configureNameLabel()
        configureSumLabel()
        configureStackView()
        configureDoneButton()
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
    
    private func configureDoneButton() {
        doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.tintColor = UIColor(named: "YP Black")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: 16),
            
            doneButton.widthAnchor.constraint(equalToConstant: 44),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func setDataInCell() {
        guard let model else {return}
        guard let purshase = model.purshase else {return}
        guard let name = model.name else {return}
        guard let date = model.date else {return}
        
        purshaseLabel.text = "Покупка: \(purshase)"
        
        if model.isToMe {
            nameLabel.text = "Должник: \(name)"
        } else {
            nameLabel.text = "Кому: \(name)"
        }
        
        if isRub {
            sumLabel.text = "Сумма: \(model.sum) руб"
        } else {
            guard let rate = conversionRateService.conversionRate?.rate else {return}
            let dollars = Double(model.sum) * rate
            let roundedNumber = Double(String(format: "%.2f", dollars))!
            sumLabel.text = "Сумма: \(roundedNumber) $"
        }
        
        dateLabel.text = dateFormatter.dayMonthAndYear(date: date)
    }
    
    @objc func doneButtonTapped() {
        delegate?.didDoneButtonTapped(self)
    }
}
