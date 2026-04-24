import Cocoa

open class CustomBridgesViewController: NSViewController {

    public let explanationLb = NSTextField(wrappingLabelWithString: "")
    public let pasteboardBt = NSButton(title: "", target: nil, action: nil)
    public let emailBt = NSButton(title: "", target: nil, action: nil)
    public let telegramBt = NSButton(title: "", target: nil, action: nil)
    public let headerLb = NSTextField(labelWithString: "")
    public let bridgesTf = NSTextField()

    open weak var delegate: BridgesConfDelegate?

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    open override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 450, height: 300))
        setupUI()
    }

    private func setupUI() {
        explanationLb.stringValue = L10n.customBridgesExplanation
        pasteboardBt.title = L10n.copyToClipboard
        pasteboardBt.action = #selector(copyToPasteboard(_:))
        pasteboardBt.target = self
        
        emailBt.title = L10n.requestViaEmail
        emailBt.action = #selector(requestViaEmail(_:))
        emailBt.target = self
        
        telegramBt.title = L10n.requestViaTelegram
        telegramBt.action = #selector(requestViaTelegram(_:))
        telegramBt.target = self
        
        headerLb.stringValue = L10n.pasteBridges
        bridgesTf.placeholderString = BuiltInBridges.shared?.obfs4?.prefix(2).map({ $0.raw }).joined(separator: "\n")
        bridgesTf.stringValue = delegate?.customBridges?.joined(separator: "\n") ?? ""

        let btnStack = NSStackView(views: [pasteboardBt, emailBt, telegramBt])
        let mainStack = NSStackView(views: [headerLb, explanationLb, bridgesTf, btnStack])
        mainStack.orientation = .vertical
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bridgesTf.heightAnchor.constraint(equalToConstant: 100),
            bridgesTf.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
        ])
    }

    // ... [Keep your existing viewWillAppear, viewWillDisappear, and Actions here] ...
}
