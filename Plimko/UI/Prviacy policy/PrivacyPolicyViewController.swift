import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    
    private let webView = WKWebView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let url = URL(string: "https://pliobeastball.com/privacy-policy.html")!
        webView.load(URLRequest(url: url))
        
        view.addSubview(backButton)
        backButton
            .activateAnchors()
            .topAnchor(to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .leadingAnchor(16)
            .dimensionAnchors(width: 50, height: 50)
    }
    
    @objc func closeAction() {
        MainRouter.shared.pop(animated: true)
    }
}

