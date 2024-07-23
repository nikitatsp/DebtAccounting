import UIKit

protocol DebtListCellDelegate: AnyObject {
    func didButtonInCellTapped(_ cell: DebtListCell, debt: Debt)
}

struct DebtListCellModel {
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
    
    var debtListCellModel: DebtListCellModel! {
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
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
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
        purshaseLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        purshaseLabel.textColor = .text
        purshaseLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = .text
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSumLabel() {
        sumLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sumLabel.textColor = .text
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.textColor = .text
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
        button.tintColor = .text
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
        guard let debtListCellModel else {return}
        let debt = debtListCellModel.debt
        guard let purshase = debt.purshase else {return}
        guard let name = debt.name else {return}
        guard let date = debt.date else {return}
        
        let purshaseText = "Покупка: \(purshase)"
        purshaseLabel.text = purshaseText
        
        let attributedString = NSMutableAttributedString(string: purshaseText)
        let boldFont = UIFont.systemFont(ofSize: purshaseLabel.font.pointSize, weight: .bold)
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
        attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 8))
        let normalFont = UIFont.systemFont(ofSize: purshaseLabel.font.pointSize)
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
        attributedString.addAttributes(normalAttributes, range: NSRange(location: 8, length: purshaseText.count - 8))
        purshaseLabel.attributedText = attributedString
        
        if debt.isI {
            let nameText = "Кому: \(name)"
            nameLabel.text = nameText
            
            let attributedString = NSMutableAttributedString(string: nameText)
            let boldFont = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: .bold)
            let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))
            let normalFont = UIFont.systemFont(ofSize: nameLabel.font.pointSize)
            let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
            attributedString.addAttributes(normalAttributes, range: NSRange(location: 5, length: nameText.count - 5))
            nameLabel.attributedText = attributedString
        } else {
            let nameText = "Должник: \(name)"
            nameLabel.text = nameText
            
            let attributedString = NSMutableAttributedString(string: nameText)
            let boldFont = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: .bold)
            let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 8))
            let normalFont = UIFont.systemFont(ofSize: nameLabel.font.pointSize)
            let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
            attributedString.addAttributes(normalAttributes, range: NSRange(location: 8, length: nameText.count - 8))
            nameLabel.attributedText = attributedString
        }
        
        if debtListCellModel.isRub {
            let sumText = "Сумма: \(debt.sum) руб"
            sumLabel.text = sumText
            
            let attributedString = NSMutableAttributedString(string: sumText)
            let boldFont = UIFont.systemFont(ofSize: sumLabel.font.pointSize, weight: .bold)
            let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 6))
            let normalFont = UIFont.systemFont(ofSize: sumLabel.font.pointSize)
            let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
            attributedString.addAttributes(normalAttributes, range: NSRange(location: 6, length: sumText.count - 6))
            sumLabel.attributedText = attributedString
        } else {
            guard let rate = debtListCellModel.conversionRateService.conversionRate?.rate else {return}
            let dollars = Double(debt.sum) * rate
            let roundedNumber = Double(String(format: "%.2f", dollars))!
            
            let sumText = "Сумма: \(roundedNumber) $"
            sumLabel.text = sumText
            
            let attributedString = NSMutableAttributedString(string: sumText)
            let boldFont = UIFont.systemFont(ofSize: sumLabel.font.pointSize, weight: .bold)
            let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 6))
            let normalFont = UIFont.systemFont(ofSize: sumLabel.font.pointSize)
            let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
            attributedString.addAttributes(normalAttributes, range: NSRange(location: 6, length: sumText.count - 6))
            sumLabel.attributedText = attributedString
        }
        
        if debt.isActive {
            button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        }
        
        dateLabel.text = debtListCellModel.dateFormatter.dayMonthAndYear(date: date)
    }
    
    @objc func didButtonInCellTapped() {
        debtListCellModel?.delegate?.didButtonInCellTapped(self, debt: debtListCellModel.debt)
    }
}
