import UIKit

public let MBProgressHUDModeCustomView: Int = 1

public class MBProgressHUD: UIView {
    public var mode: Int = 0
    public var customView: UIView? {
        didSet {
            if let cv = customView {
                spinner.stopAnimating()
                cv.translatesAutoresizingMaskIntoConstraints = false
                bezelView.addSubview(cv)
                NSLayoutConstraint.activate([
                    cv.centerXAnchor.constraint(equalTo: bezelView.centerXAnchor),
                    cv.centerYAnchor.constraint(equalTo: bezelView.centerYAnchor)
                ])
            }
        }
    }
    
    private let bezelView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let spinner = UIActivityIndicatorView(style: .large)

    @discardableResult
    public static func showAdded(to view: UIView, animated: Bool) -> MBProgressHUD {
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
        UIView.animate(withDuration: animated ? 0.3 : 0, delay: delay, options: [], animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        bezelView.layer.cornerRadius = 10
        bezelView.clipsToBounds = true
        bezelView.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        addSubview(bezelView)
        bezelView.contentView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            bezelView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bezelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bezelView.widthAnchor.constraint(equalToConstant: 90),
            bezelView.heightAnchor.constraint(equalToConstant: 90),
            spinner.centerXAnchor.constraint(equalTo: bezelView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: bezelView.centerYAnchor)
        ])
    }
}
