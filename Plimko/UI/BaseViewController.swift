import UIKit

class BaseViewController: UIViewController {
    private let background: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: R.Background.menu.rawValue)
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(background)
        
        background
            .activateAnchors()
            .equalToSuperview()
    }
}
