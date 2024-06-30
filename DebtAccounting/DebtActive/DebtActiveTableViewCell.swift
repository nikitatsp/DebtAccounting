import UIKit

protocol DebtActiveTableViewCellDelegate: AnyObject {
    func didDoneButtonTapped(_ cell: DebtActiveTableViewCell)
}

class DebtActiveTableViewCell: UITableViewCell {
    static let reuseIdentifier = "Activecell"
    
    var nameLabel = UILabel()
    var sumLabel = UILabel()
    private let stackView = UIStackView()
    var doneButton = UIButton()
    
    weak var delegate: DebtActiveTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureNameLabel()
        configureSumLabel()
        configureStackView()
        configureDoneButton()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
    private func configureStackView() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(sumLabel)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureDoneButton() {
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
            doneButton.widthAnchor.constraint(equalToConstant: 44),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func doneButtonTapped() {
        delegate?.didDoneButtonTapped(self)
    }
}
