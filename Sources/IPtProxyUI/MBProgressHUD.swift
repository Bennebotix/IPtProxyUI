import AppKit

public class MBProgressHUD: NSView {
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

    public static func hide(for view: NSView, animated: Bool) -> Bool {
        let huds = view.subviews.filter { $0 is MBProgressHUD }
        huds.forEach { $0.removeFromSuperview() }
        return !huds.isEmpty
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

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
        addSubview(spinner)
        
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
