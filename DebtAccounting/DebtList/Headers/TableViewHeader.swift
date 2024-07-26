import UIKit

final class TableViewHeader: UIView {
    private let tittleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        tittleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        self.addSubview(tittleLabel)
        tittleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tittleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tittleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setDataInHeader(text: String) {
        tittleLabel.text = text
    }
}
