import UIKit

open class BridgesConfViewController: UIViewController {

    public var transport: Transport = .none
    open weak var delegate: BridgesConfDelegate?
    
    // UI Elements
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let countryTextField = UITextField() // Replacement for ComboBox
    private let saveButton = UIButton(type: .system)

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) { fatalError() }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        titleLabel.text = "Bridge Configuration"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        countryTextField.borderStyle = .roundedRect
        countryTextField.placeholder = "Select Country"
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countryTextField)
        stackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func saveTapped() {
        delegate?.save()
        dismiss(animated: true)
    }
}
