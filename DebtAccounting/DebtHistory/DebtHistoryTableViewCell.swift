import UIKit

protocol DebtHistoryTableViewCellDelegate: AnyObject {
    func didBackButtonTapped(_ cell: DebtHistoryTableViewCell)
}

final class DebtHistoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "cell"
    
    var nameLabel = UILabel()
    var sumLabel = UILabel()
    private let stackView = UIStackView()
    private var backButton = UIButton()
    
    weak var delegate: DebtHistoryTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureNameLabel()
        configureSumLabel()
        configureStackView()
        configureBackButton()
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
    
    func configureBackButton() {
        backButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = UIColor(named: "YP Black")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func backButtonTapped() {
        delegate?.didBackButtonTapped(self)
    }
}
