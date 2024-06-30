import UIKit

protocol DataViewControllerDelegate: AnyObject {
    func didTapBackButton()
    func didTapSaveBarButton(model: Model)
}

final class DataViewController: UIViewController {
    private let dateFormatter = FormatDate.shared
    
    var date = Date()
    weak var delegate: DataViewControllerDelegate?
    var isToMe = false
    
    private let backBarButtonItem = UIBarButtonItem()
    private let saveBarButtonItem = UIBarButtonItem()
    
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let nameStackView = UIStackView()
    
    private let sumLabel = UILabel()
    private let sumTextField = UITextField()
    private let sumStackView = UIStackView()
    
    private let telegramLabel = UILabel()
    private let telegramTextField = UITextField()
    private let telegramStackView = UIStackView()
    
    private let phoneLabel = UILabel()
    private let phoneTextField = UITextField()
    private let phoneStackView = UIStackView()
    
    private let mainStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationItem()
        configureNameStackView()
        configureSumStackView()
        configureTelegramStackView()
        configurePhoneStackView()
        configureMainStackView()
        
        setConstraints()
    }
    
    private func configureNavigationItem() {
        guard let ypBlackColor = UIColor(named: "YP Black") else {return}
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ypBlackColor]
        
        navigationItem.title = dateFormatter.formatDateToString(date: date)
        
        backBarButtonItem.image = UIImage(systemName: "chevron.backward")
        backBarButtonItem.tintColor = UIColor(named: "YP Black")
        navigationItem.leftBarButtonItem = backBarButtonItem
        backBarButtonItem.target = self
        backBarButtonItem.action = #selector(didTapBackButton)
        
        saveBarButtonItem.title = "Save"
        saveBarButtonItem.tintColor = UIColor(named: "YP Black")
        navigationItem.rightBarButtonItem = saveBarButtonItem
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(didTapSaveButton)
        saveBarButtonItem.isEnabled = false
    }
    
    private func configureNameStackView() {
        nameLabel.text = "Должник"
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = UIColor(named: "YP Black")
        
        nameTextField.font = UIFont.systemFont(ofSize: 17)
        nameTextField.textColor = UIColor(named: "YP Black")
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocapitalizationType = .sentences
        nameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        nameStackView.axis = .vertical
        nameStackView.alignment = .fill
        nameStackView.distribution = .fillEqually
        nameStackView.spacing = 8
    }
    
    private func configureSumStackView() {
        sumLabel.text = "Сумма"
        sumLabel.font = UIFont.systemFont(ofSize: 17)
        sumLabel.textColor = UIColor(named: "YP Black")
        
        sumTextField.font = UIFont.systemFont(ofSize: 17)
        sumTextField.textColor = UIColor(named: "YP Black")
        sumTextField.borderStyle = .roundedRect
        sumTextField.keyboardType = .numberPad
        sumTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        sumStackView.addArrangedSubview(sumLabel)
        sumStackView.addArrangedSubview(sumTextField)
        sumStackView.axis = .vertical
        sumStackView.alignment = .fill
        sumStackView.distribution = .fillEqually
        sumStackView.spacing = 8
    }
    
    private func configureTelegramStackView() {
        telegramLabel.text = "Телеграм"
        telegramLabel.font = UIFont.systemFont(ofSize: 17)
        telegramLabel.textColor = UIColor(named: "YP Black")
        
        telegramTextField.font = UIFont.systemFont(ofSize: 17)
        telegramTextField.textColor = UIColor(named: "YP Black")
        telegramTextField.borderStyle = .roundedRect
        
        telegramStackView.addArrangedSubview(telegramLabel)
        telegramStackView.addArrangedSubview(telegramTextField)
        telegramStackView.axis = .vertical
        telegramStackView.alignment = .fill
        telegramStackView.distribution = .fillEqually
        telegramStackView.spacing = 8
    }
    
    private func configurePhoneStackView() {
        phoneLabel.text = "Телефон"
        phoneLabel.font = UIFont.systemFont(ofSize: 17)
        phoneLabel.textColor = UIColor(named: "YP Black")
        
        phoneTextField.font = UIFont.systemFont(ofSize: 17)
        phoneTextField.textColor = UIColor(named: "YP Black")
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .numberPad
        
        phoneStackView.addArrangedSubview(phoneLabel)
        phoneStackView.addArrangedSubview(phoneTextField)
        phoneStackView.axis = .vertical
        phoneStackView.alignment = .fill
        phoneStackView.distribution = .fillEqually
        phoneStackView.spacing = 8
    }
    
    private func configureMainStackView() {
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(sumStackView)
        mainStackView.addArrangedSubview(telegramStackView)
        mainStackView.addArrangedSubview(phoneStackView)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 35
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameStackView.widthAnchor.constraint(equalToConstant: 300),
            nameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    @objc private func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc private func didTapSaveButton() {
        guard let nameText = nameTextField.text else {print("Выход из за имени")
            return}
        guard let sumtext = sumTextField.text, let sum = Int(sumtext) else {print("Выход из за суммы")
            return}
        
        var model = Model(name: nameText, sum: sum, isToMe: isToMe, isHist: false, date: date)
        
        if let phoneText = phoneTextField.text {
            let phone = Int(phoneText)
            model.phone = phone
        }
        
        if telegramTextField.text != "" {
            model.telegram = telegramTextField.text
        }
        
        delegate?.didTapSaveBarButton(model: model)
        
    }
    
    @objc private func editingChanged() {
        let isNameFieldFilled = !(nameTextField.text?.isEmpty ?? true)
        let isSumFieldFilled = !(sumTextField.text?.isEmpty ?? true)
        saveBarButtonItem.isEnabled = isNameFieldFilled && isSumFieldFilled
    }
}
