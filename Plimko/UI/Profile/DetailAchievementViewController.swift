import UIKit

final class DetailAchievementViewController: BaseViewController {
    
    private let achievement: Achievement?
    private let service = AchievementsService.shared
    
    private let achievementImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let descriptionBackground: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.midFrame.rawValue)
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let achievementDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "Moul-Regular", size: 20)
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
    
    init(id: Int) {
        self.achievement = service.achievement(by: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        achievementImage.image = UIImage(named: achievement?.imageName ?? "")
        achievementDescription.text = achievement?.description
        
        view.addSubview(descriptionBackground)
        view.addSubview(achievementImage)
        view.addSubview(backButton)
        descriptionBackground.addSubview(achievementDescription)
        
        descriptionBackground
            .activateAnchors()
            .centerToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.8)
            .aspectRatio(width: 1, height: 1.16)
        
        achievementImage
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(to: descriptionBackground.topAnchor, constant: 100)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.7)
            .aspectRatio(width: 1, height: 1)
        
        achievementDescription
            .activateAnchors()
            .topAnchor(to: achievementImage.bottomAnchor, constant: 20)
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
        MainRouter.shared.dismiss()
    }
}
