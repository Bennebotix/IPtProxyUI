import AppKit

public let MBProgressHUDModeCustomView: Int = 1

public class MBProgressHUD: NSView {
    public var mode: Int = 0
    public var customView: NSView? {
        didSet {
            if let cv = customView {
                spinner.isHidden = true
                cv.translatesAutoresizingMaskIntoConstraints = false
                visualEffectView.addSubview(cv)
                NSLayoutConstraint.activate([
                    cv.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
                    cv.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor)
                ])
            }
        }
    }
    
    private let visualEffectView = NSVisualEffectView()
    private let spinner = NSProgressIndicator()

    @discardableResult
    public static func showAdded(to view: NSView, animated: Bool) -> MBProgressHUD {
        let hud = MBProgressHUD(frame: view.bounds)
        view.addSubview(hud)
        hud.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hud.topAnchor.constraint(equalTo: view.topAnchor),
            hud.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hud.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hud.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return hud
    }

    public func hide(_ animated: Bool, afterDelay delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.removeFromSuperview()
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        visualEffectView.blendingMode = .withinWindow
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.layer?.cornerRadius = 10
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.style = .spinning
        spinner.controlSize = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimation(nil)

        addSubview(visualEffectView)
        visualEffectView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            visualEffectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            visualEffectView.centerYAnchor.constraint(equalTo: centerYAnchor),
            visualEffectView.widthAnchor.constraint(equalToConstant: 90),
            visualEffectView.heightAnchor.constraint(equalToConstant: 90),
            spinner.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor)
        ])
    }
}
