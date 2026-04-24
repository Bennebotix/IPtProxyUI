import Cocoa

open class BridgesConfViewController: NSViewController, BridgesConfDelegate, NSWindowDelegate, NSComboBoxDataSource, NSComboBoxDelegate {

    open weak var delegate: BridgesConfDelegate?
    private var filteredCountries = Country.all
    open var customBridges: [String]?
    
    // UI Elements (Replaces Outlets)
    public let autoConfBox = NSBox()
    public let cannotConnectLb = NSTextField(labelWithString: "")
    public let cannotConnectSw = NSSwitch()
    public let countryCb = NSComboBox()
    public let tryAutoConfBt = NSButton(title: "", target: nil, action: nil)
    public let noBridgesRb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let obfs4Rb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let snowflakeRb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let snowflakeAmpRb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let meekRb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let dnsttRb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let customBridgesRb = NSButton(radioButtonWithTitle: "", target: nil, action: nil)
    public let descLb = NSTextField(wrappingLabelWithString: "")
    public let cancelBt = NSButton(title: "", target: nil, action: nil)
    public let saveBt = NSButton(title: "", target: nil, action: nil)
    
    open var customBridgesRbTopConstraint: NSLayoutConstraint?

    open var transport: Transport = .none {
        didSet {
            Task { @MainActor in
                [noBridgesRb, obfs4Rb, snowflakeRb, snowflakeAmpRb, meekRb, dnsttRb, customBridgesRb].forEach { $0.state = .off }
                switch transport {
                case .obfs4: obfs4Rb.state = .on; announce(obfs4Rb.title)
                case .snowflake: snowflakeRb.state = .on; announce(snowflakeRb.title)
                case .snowflakeAmp: snowflakeAmpRb.state = .on; announce(snowflakeAmpRb.title)
                case .meek: meekRb.state = .on; announce(meekRb.title)
                case .dnstt: dnsttRb.state = .on; announce(dnsttRb.title)
                case .custom: customBridgesRb.state = .on; announce(customBridgesRb.title)
                default: noBridgesRb.state = .on; announce(noBridgesRb.title)
                }
            }
        }
    }

    open var countryCode: String? {
        get { delegate?.countryCode ?? Settings.countryCode }
        set { delegate?.countryCode = newValue; Settings.countryCode = newValue }
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    open override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 450))
        setupProgrammaticUI()
    }

    private func setupProgrammaticUI() {
        // Apply logic from your old 'didSet' observers
        autoConfBox.title = L10n.automaticConfiguration
        cannotConnectLb.stringValue = L10n.cannotConnect
        cannotConnectSw.setAccessibilityLabel(L10n.cannotConnect)
        countryCb.placeholderString = L10n.myCountry
        countryCb.stringValue = Country.selected(countryCode)?.description ?? ""
        countryCb.dataSource = self
        countryCb.delegate = self
        tryAutoConfBt.title = L10n.tryAutoConfiguration
        tryAutoConfBt.action = #selector(tryAutoConf(_:))
        tryAutoConfBt.target = self
        
        noBridgesRb.title = L10n.noBridges
        obfs4Rb.title = L10n.builtInObfs4
        snowflakeRb.title = L10n.builtInSnowflake
        snowflakeAmpRb.title = L10n.builtInSnowflakeAmp
        meekRb.title = L10n.builtInMeek
        dnsttRb.title = L10n.builtInDnstt
        customBridgesRb.title = L10n.customBridges
        
        [noBridgesRb, obfs4Rb, snowflakeRb, snowflakeAmpRb, meekRb, dnsttRb, customBridgesRb].forEach {
            $0.target = self
            $0.action = #selector(selectBridge(_:))
        }

        descLb.stringValue = L10n.bridgeTypeExplanation
        cancelBt.title = L10n.cancel
        cancelBt.action = #selector(cancel(_:))
        cancelBt.target = self
        saveBt.action = #selector(save(_:))
        saveBt.target = self

        // Layout using a StackView
        let mainStack = NSStackView(views: [autoConfBox, noBridgesRb, obfs4Rb, snowflakeRb, snowflakeAmpRb, meekRb, dnsttRb, customBridgesRb, descLb])
        mainStack.orientation = .vertical
        mainStack.alignment = .leading
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        let footerStack = NSStackView(views: [cancelBt, saveBt])
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerStack)

        // Inside AutoConfBox
        let innerBoxStack = NSStackView(views: [cannotConnectLb, cannotConnectSw, countryCb, tryAutoConfBt])
        innerBoxStack.orientation = .vertical
        innerBoxStack.alignment = .leading
        autoConfBox.contentView = innerBoxStack
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            footerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            footerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // ... [Keep all your existing Actions and Methods here (tryAutoConf, selectBridge, etc.)] ...
    // Note: Ensure @IBAction is removed or kept as @objc for the programmatic targets
}
