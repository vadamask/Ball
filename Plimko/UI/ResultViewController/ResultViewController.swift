import UIKit

final class ResultViewController: UIViewController {

    private let isWin: Bool
    private let level: Level
    private let levelsService = LevelsService.shared
    
    private let background: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: R.Background.result.rawValue)
        return view
    }()
    
    private lazy var result: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: isWin ? R.Game.win.rawValue : R.Game.lose.rawValue)
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: isWin ? R.Button.next.rawValue : R.Button.again.rawValue), for: .normal)
        button.setImage(UIImage(named: isWin ? R.Button.next.rawValue : R.Button.again.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.menuRect.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.menuRect.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let resultBackground: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.midFrame.rawValue)
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let yourScoreText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Moul-Regular", size: 20) as Any,
            .strokeColor: UIColor(hex: "#F2BF54"),
            .strokeWidth: -4
        ]
        let attrText = NSAttributedString(string: "YOUR SCORE", attributes: attributes)
        
        label.attributedText = attrText
       
        return label
    }()
    
    private let bestScoreText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Moul-Regular", size: 18) as Any,
            .strokeColor: UIColor(hex: "#F2BF54"),
            .strokeWidth: -4
        ]
        let attrText = NSAttributedString(string: "BEST SCORE", attributes: attributes)
        
        label.attributedText = attrText
       
        return label
    }()
    
    private let yourScore: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Moul-Regular", size: 70) as Any,
            .strokeColor: UIColor(hex: "#F2BF54"),
            .strokeWidth: -2
        ]
        let attrText = NSAttributedString(string: "1560", attributes: attributes)
        
        label.attributedText = attrText
       
        return label
    }()
    
    private let bestScore: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init(isWin: Bool, id: Int, seconds: Int) {
        self.isWin = isWin
        self.level = levelsService.level(by: id)
        super.init(nibName: nil, bundle: nil)
        
        if isWin {
            yourScore.text = seconds.description
            
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "Moul-Regular", size: 50) as Any,
                .strokeColor: UIColor(hex: "#F2BF54"),
                .strokeWidth: -2
            ]
            let attrText = NSAttributedString(string: levelsService.getBestResult(id).time.description, attributes: attributes)
            
            bestScore.attributedText = attrText
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(background)
        view.addSubview(result)
        view.addSubview(nextButton)
        view.addSubview(menuButton)
        
        background.activateAnchors().equalToSuperview()
        
        result
            .activateAnchors()
            .centerToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.8)
            .aspectRatio(width: 1, height: 1.3)
        
        nextButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: result.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
        
        menuButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: nextButton.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
        
        if isWin {
            view.insertSubview(resultBackground, belowSubview: result)
            resultBackground.addSubview(yourScoreText)
            resultBackground.addSubview(bestScoreText)
            resultBackground.addSubview(yourScore)
            resultBackground.addSubview(bestScore)
            
            resultBackground
                .activateAnchors()
                .centerXToSuperview()
                .widthAnchor(to: view.widthAnchor, multiplier: 0.7)
                .aspectRatio(width: 1, height: 1.2)
                .bottomAnchor(to: result.topAnchor, constant: 40)
            
            yourScoreText
                .activateAnchors()
                .topAnchor(15)
                .centerXToSuperview()
                .heightAnchor(to: resultBackground.heightAnchor, multiplier: 0.1)
            
            yourScore
                .activateAnchors()
                .centerXToSuperview()
                .topAnchor(to: yourScoreText.bottomAnchor)
                .heightAnchor(to: resultBackground.heightAnchor, multiplier: 0.3)
            
            bestScoreText
                .activateAnchors()
                .centerXToSuperview()
                .topAnchor(to: yourScore.bottomAnchor, constant: 15)
                .heightAnchor(to: resultBackground.heightAnchor, multiplier: 0.1)
            
            bestScore
                .activateAnchors()
                .centerXToSuperview()
                .topAnchor(to: bestScoreText.bottomAnchor)
                .heightAnchor(to: resultBackground.heightAnchor, multiplier: 0.2)
        }
    }

    @objc private func buttonTapped() {
        if isWin {
            MainRouter.shared.showGameWithPopPrevious(level: level.id + 1)
        } else {
            MainRouter.shared.showGameWithPopPrevious(level: level.id)
        }
    }
    
    @objc private func menuButtonTapped() {
        MainRouter.shared.popToRoot()
    }
}
