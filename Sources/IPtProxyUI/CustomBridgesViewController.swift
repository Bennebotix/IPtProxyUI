import UIKit

open class CustomBridgesViewController: UIViewController {

    public let headerLb: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    public let explanationLb: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    public let bridgesTf: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.layer.cornerRadius = 8
        tv.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        return tv
    }()

    public let pasteboardBt = UIButton(type: .system)
    public let emailBt = UIButton(type: .system)
    public let telegramBt = UIButton(type: .system)

    open weak var delegate: BridgesConfDelegate?

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.title
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Sync the text back to the delegate/settings
        Helpers.update(delegate: delegate, bridgesTf.text)
    }

    private func setupUI() {
        // Set localized strings
        headerLb.text = L10n.pasteBridges
        explanationLb.text = L10n.customBridgesExplanation
        
        pasteboardBt.setTitle(L10n.copyToClipboard, for: .normal)
        pasteboardBt.addTarget(self, action: #selector(copyToPasteboard(_:)), for: .touchUpInside)
        
        emailBt.setTitle(L10n.requestViaEmail, for: .normal)
        emailBt.addTarget(self, action: #selector(requestViaEmail(_:)), for: .touchUpInside)
        
        telegramBt.setTitle(L10n.requestViaTelegram, for: .normal)
        telegramBt.addTarget(self, action: #selector(requestViaTelegram(_:)), for: .touchUpInside)

        // Setup Bridge Text View logic
        bridgesTf.text = delegate?.customBridges?.joined(separator: "\n") ?? ""
        
        // Layout using UIStackView
        let btnStack = UIStackView(arrangedSubviews: [pasteboardBt, emailBt, telegramBt])
        btnStack.axis = .vertical
        btnStack.spacing = 8
        btnStack.alignment = .fill

        let mainStack = UIStackView(arrangedSubviews: [headerLb, explanationLb, bridgesTf, btnStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bridgesTf.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    // MARK: Actions

    @objc func copyToPasteboard(_ sender: Any) {
        UIPasteboard.general.url = Constants.bridgesUrl
        // Optional: show a small HUD or alert that it was copied
    }

    @objc func requestViaEmail(_ sender: Any) {
        let email = Constants.emailRecipient
        let subject = Constants.emailSubjectAndBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(subject)") {
            UIApplication.shared.open(url)
        }
    }

    @objc func requestViaTelegram(_ sender: Any) {
        UIApplication.shared.open(Constants.telegramBot)
    }
}
