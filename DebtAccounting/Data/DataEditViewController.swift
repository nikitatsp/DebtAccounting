import UIKit
import CoreData

protocol DataEditViewControllerDelegate: AnyObject {
    func didTapBackButton()
    func didTapEditSaveBarButton(indexPath: IndexPath, model: Model, firstModel: Model)
}

final class DataEditViewController: UIViewController {
    private let dateFormatter = DateService.shared
    private let context = CoreDataService.shared.getContext()
    
    var indexPath: IndexPath?
    var model: Model?
    weak var delegate: DataEditViewControllerDelegate?
    
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
        configureCells()
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
        view.addSubview(datePicker)
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
        
        view.addSubview(mainStackView)
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
        delegate?.didTapBackButton()
    }
    
    @objc private func didTapSaveButton() {
        guard let purshaseText = purshaseTextField.text else { print("Выход из за покупки")
            return}
        guard let nameText = nameTextField.text else { print("Выход из за имени")
            return}
        guard let sumtext = sumTextField.text, let sum = Int(sumtext) else { print("Выход из за суммы")
            return}
        guard let isToMe = model?.isToMe else { print("Выход из-за isToMe")
            return}
        guard let isHist = model?.isHist else { print("Выход из-за isHist")
            return
        }
        guard let indexPath else { print("Выход из-за indexPath")
            return
        }
        guard let model else {return}
        
        let secondModel = Model(context: context)
        secondModel.purshase = purshaseText
        secondModel.name = nameText
        secondModel.sum = Int64(sum)
        secondModel.isToMe = isToMe
        secondModel.isHist = isHist
        secondModel.date = datePicker.date
        
        if phoneTextField.text != "" {
            if let phoneText = phoneTextField.text {
                if let phone = Int64(phoneText) {
                    secondModel.phone = phone
                }
            }
        }
        
        if telegramTextField.text != "" {
            secondModel.telegram = telegramTextField.text
        }
        
        delegate?.didTapEditSaveBarButton(indexPath: indexPath, model: secondModel, firstModel: model)
        
    }
    
    @objc private func editingChanged() {
        let isPurshaseFieldFilled = !(purshaseTextField.text?.isEmpty ?? true)
        let isNameFieldFilled = !(nameTextField.text?.isEmpty ?? true)
        let isSumFieldFilled = !(sumTextField.text?.isEmpty ?? true)
        saveBarButtonItem.isEnabled = isNameFieldFilled && isSumFieldFilled && isPurshaseFieldFilled
    }
}

//MARK: - ObserveKeyboard

extension DataEditViewController {
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

//MARK: - configureCells

extension DataEditViewController {
    private func configureCells() {
        guard let model else {return}
        guard let date = model.date else {return}
        guard let purshase = model.purshase else {return}
        
        datePicker.date = date
        purshaseTextField.text = purshase
        nameTextField.text = model.name
        sumTextField.text = "\(model.sum)"
        telegramTextField.text = model.telegram
        
        if model.phone == 0 {
            phoneTextField.text = ""
        } else {
            phoneTextField.text = "\(model.phone)"
        }
    }
}
