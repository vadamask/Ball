import UIKit

final class TestResultViewController: BaseViewController {
    
    private let logo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: R.App.logo.rawValue)
        return view
    }()
    
    private let descriptionBackground: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.midFrame.rawValue)
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let resultDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "Moul-Regular", size: 20)
        label.text = "You have successfully completed the tutorial level. Now try to complete all levels!"
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.back.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.back.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(descriptionBackground)
        view.addSubview(logo)
        view.addSubview(backButton)
        descriptionBackground.addSubview(resultDescription)
        
        descriptionBackground
            .activateAnchors()
            .centerToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.8)
            .aspectRatio(width: 1, height: 1.16)
        
        logo
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(to: descriptionBackground.topAnchor, constant: 100)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.7)
            .aspectRatio(width: 1, height: 1)
        
        resultDescription
            .activateAnchors()
            .topAnchor(to: logo.bottomAnchor, constant: -20)
            .leadingAnchor(20)
            .trailingAnchor(-20)
            .bottomAnchor(-20)
        
        backButton
            .activateAnchors()
            .topAnchor(to: descriptionBackground.bottomAnchor, constant: 20)
            .centerXToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
    }
    
    @objc private func backButtonTapped() {
        MainRouter.shared.popToRoot()
    }
}
