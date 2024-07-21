import UIKit

//MARK: - Protocols

protocol DataScreenViewControllerInputProtocol: AnyObject {
    func setTextInNameLabel(text: String)
    func updateSaveButton(isEnabled: Bool)
    func fillDataScreen(date: Date?, purshase: String?, name: String?, sum: Int64, telegram: String?, phone: String?)
}

protocol DataScreenViewControllerOutputProtocol {
    init(view: DataScreenViewControllerInputProtocol, isI: Bool, isActive: Bool, debt: Debt?, indexOfLastSection: Int?, delegate: DataScreenViewControllerDelegate)
    func viewDidLoad()
    func didTapSaveButton(date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?)
    func textFieldDidChange(purshaseText: String?, nameText: String?, sumText: String?)
}

//MARK: - DataScreenViewController

final class DataScreenViewController: UIViewController {
    var presenter: DataScreenViewControllerOutputProtocol!
    
    var activeTextField: UITextField?
    
    private let backBarButtonItem = UIBarButtonItem()
    private let saveBarButtonItem = UIBarButtonItem()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var heightContentView = NSLayoutConstraint()
    
    private let datePicker = UIDatePicker()
    
    private let purshaseLabel = UILabel()
    private let purshaseTextField = UITextField()
    private let purshaseStackView = UIStackView()
    
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
        configureScrollView()
        configureDatePicker()
        configureMainStackView()
        setConstraints()
        hideKeyboardWhenTappedAround()
        observeKeyboard()
        
        presenter.viewDidLoad()
    }
    
    private func configureNavigationItem() {
        guard let ypBlackColor = UIColor(named: "YP Black") else {return}
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ypBlackColor]
        navigationItem.title = ""
        
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
    
    private func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        heightContentView = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightContentView
        ])
    }
    
    private func configureDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.date = Date()
        contentView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePurshaseStackView() {
        purshaseLabel.text = "Покупка"
        purshaseLabel.font = UIFont.systemFont(ofSize: 17)
        purshaseLabel.textColor = UIColor(named: "YP Black")
        
        purshaseTextField.font = UIFont.systemFont(ofSize: 17)
        purshaseTextField.textColor = UIColor(named: "YP Black")
        purshaseTextField.borderStyle = .roundedRect
        purshaseTextField.autocapitalizationType = .sentences
        purshaseTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        purshaseTextField.delegate = self
        
        purshaseStackView.addArrangedSubview(purshaseLabel)
        purshaseStackView.addArrangedSubview(purshaseTextField)
        purshaseStackView.axis = .vertical
        purshaseStackView.alignment = .fill
        purshaseStackView.distribution = .fillEqually
        purshaseStackView.spacing = 8
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
        nameTextField.delegate = self
        
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
        sumTextField.delegate = self
        
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
        telegramTextField.delegate = self
        
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
        phoneTextField.delegate = self
        
        phoneStackView.addArrangedSubview(phoneLabel)
        phoneStackView.addArrangedSubview(phoneTextField)
        phoneStackView.axis = .vertical
        phoneStackView.alignment = .fill
        phoneStackView.distribution = .fillEqually
        phoneStackView.spacing = 8
    }
    
    private func configureMainStackView() {
        configurePurshaseStackView()
        configureNameStackView()
        configureSumStackView()
        configureTelegramStackView()
        configurePhoneStackView()
        
        mainStackView.addArrangedSubview(purshaseStackView)
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(sumStackView)
        mainStackView.addArrangedSubview(telegramStackView)
        mainStackView.addArrangedSubview(phoneStackView)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 35
        
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            datePicker.heightAnchor.constraint(equalToConstant: 35),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 35),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        presenter.didTapSaveButton(date: datePicker.date, purshase: purshaseTextField.text!, name: nameTextField.text!, sum: sumTextField.text!, telegram: telegramTextField.text, phone: phoneTextField.text)
    }
    
    @objc private func editingChanged() {
        presenter.textFieldDidChange(purshaseText: purshaseTextField.text, nameText: nameTextField.text, sumText: sumTextField.text)
    }
}

//MARK: - ObserveKeyboard

extension DataScreenViewController {
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            guard let userInfo = notification.userInfo, let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardFrameValue.cgRectValue
            let keyboardHeight = keyboardFrame.size.height
            
            guard let activeTextField = self.activeTextField else {return}
            let textFieldFrameInView = activeTextField.convert(activeTextField.bounds, to: view)
            
            let distanceToBottom = view.bounds.height - textFieldFrameInView.maxY
            
            if keyboardHeight > distanceToBottom {
                scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight - distanceToBottom + 10)
                heightContentView.constant = keyboardHeight - distanceToBottom + 10
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.scrollView.contentOffset = CGPoint.zero
            self.heightContentView.constant = 0
        }
    }
}

//MARK: - UITextFieldDelegate

extension DataScreenViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField == textField {
            activeTextField = nil
        }
    }
}

//MARK: - DataScreenViewControllerInputProtocol

extension DataScreenViewController: DataScreenViewControllerInputProtocol {
    func setTextInNameLabel(text: String) {
        nameLabel.text = text
    }
    
    func updateSaveButton(isEnabled: Bool) {
        saveBarButtonItem.isEnabled = isEnabled
    }
    
    func fillDataScreen(date: Date?, purshase: String?, name: String?, sum: Int64, telegram: String?, phone: String?) {
        datePicker.date = date ?? Date()
        purshaseTextField.text = purshase
        nameTextField.text = name
        sumTextField.text = "\(sum)"
        telegramTextField.text = telegram
        phoneTextField.text = phone
    }
}
