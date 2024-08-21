import UIKit

final class DetailLevelViewController: UIViewController {
    
    private let id: Int
    
    private let background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.detailLevel.rawValue)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.playRect.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.playRect.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var statButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(statButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.stat.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.stat.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let levelView: LevelView = {
        let view = LevelView()
        view.background.image = UIImage(named: R.Game.level.rawValue)
        view.number.font = UIFont(name: "Moul-Regular", size: 80)
        return view
    }()
    
    init(id: Int) {
        self.id = id
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
        levelView.number.text = String(id)
        
        view.addSubview(background)
        view.addSubview(playButton)
        view.addSubview(backButton)
        view.addSubview(statButton)
        view.addSubview(levelView)
        
        background.activateAnchors().equalToSuperview()
        
        playButton
            .activateAnchors()
            .centerToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
        
        statButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: playButton.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
        
        backButton
            .activateAnchors()
            .topAnchor(to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .leadingAnchor(16)
            .dimensionAnchors(width: 50, height: 50)
        
        levelView
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(to: playButton.topAnchor, constant: -10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
    }
    
    @objc private func playButtonTapped() {
        MainRouter.shared.showGame(level: id)
    }
    
    @objc private func backButtonTapped() {
        MainRouter.shared.pop(animated: true)
    }
    
    @objc private func statButtonTapped() {
        MainRouter.shared.showStat(id: id)
    }
}
