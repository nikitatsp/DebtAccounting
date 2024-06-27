import UIKit

class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "cell"
    
    var nameLabel = UILabel()
    var sumLabel = UILabel()
    private let stackView = UIStackView()
    private lazy var backButton = UIButton()
    private lazy var doneButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureNameLabel()
        configureSumLabel()
        configureStackView()
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
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func addBackButton() {
        backButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = UIColor(named: "YP Black")
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func addDoneButton() {
        doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.tintColor = UIColor(named: "YP Black")
        
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalToConstant: 44),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func backButtonTapped() {}
    @objc func doneButtonTapped() {}
}
