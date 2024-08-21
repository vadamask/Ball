import UIKit

final class MenuViewController: BaseViewController {

    private let logo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: R.App.logo.rawValue)
        return view
    }()
    
    private lazy var selectLevelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectLevelButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.selectLevel.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.selectLevel.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var tutorialButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tutorialButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.tutorial.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.tutorial.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.profile.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.profile.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var storeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(storeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.store.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.store.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var privacyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.privacy.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.privacy.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(logo)
        view.addSubview(selectLevelButton)
        view.addSubview(tutorialButton)
        view.addSubview(profileButton)
        view.addSubview(storeButton)
        view.addSubview(privacyButton)
       
        logo
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(to: selectLevelButton.topAnchor, constant: -20)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.7)
            .aspectRatio(width: 1, height: 1)
        
        selectLevelButton
            .activateAnchors()
            .centerToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
     
        tutorialButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: selectLevelButton.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
     
        profileButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: tutorialButton.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
     
        storeButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: profileButton.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
     
        privacyButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: storeButton.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
    }
    
    @objc private func selectLevelButtonTapped() {
        MainRouter.shared.showMap()
    }
    
    @objc private func tutorialButtonTapped() {
        MainRouter.shared.showGame(level: 0)
    }
    
    @objc private func profileButtonTapped() {
        MainRouter.shared.showProfile()
    }
    
    @objc private func storeButtonTapped() {
        MainRouter.shared.showStore()
    }
    
    @objc private func privacyButtonTapped() {
        MainRouter.shared.showPrivacy()
    }
}
