import UIKit

final class SelectLevelViewController: UIViewController {
    
    private var levelViews: [LevelView] = []
    private var levels: [Level] = []
    private let levelsService = LevelsService.shared
    private var isRefreshed = false
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(hex: "#3801AD")
        view.contentInsetAdjustmentBehavior = .never
        view.bounces = false
        return view
    }()
    
    private let map: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.map.rawValue)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let topLabel: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Label.levels.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateLevels()
        layoutLevels()
        isRefreshed = false
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        
        if !isRefreshed {
            setupRouteLayers()
            isRefreshed = true
        }
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        view.addSubview(backButton)
        scrollView.addSubview(map)
        scrollView.addSubview(topLabel)
        
       backButton
            .activateAnchors()
            .topAnchor(to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .leadingAnchor(16)
            .dimensionAnchors(width: 50, height: 50)
        
        scrollView
            .activateAnchors()
            .equalToSuperview()
        
        map
            .activateAnchors()
            .equalToSuperview()
            .widthToSuperview()
        
        topLabel
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(80)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.7)
            .aspectRatio(width: 1, height: 2)
    }
    
    private func generateLevels() {
        levels = levelsService.getLevels()
        levelViews.removeAll()
        
        for i in 1...100 {
            let view = LevelView()
            view.configure(levels[i-1])
            levelViews.append(view)
        }
    }
    
    private func layoutLevels() {
        var previousView: UIView = topLabel
        
        levelViews.enumerated().forEach { index, view in
            
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(levelDidTapped)))
            
            scrollView.addSubview(view)
            
            view
                .activateAnchors()
                .centerXToSuperview(index.isMultiple(of: 2) ? -100 : 100)
                .topAnchor(to: previousView.bottomAnchor, constant: 10)
                .dimensionAnchors(width: 100, height: 100)
            
            previousView = view
        }
        previousView.bottomAnchor(-30)
    }
    
    private func setupRouteLayers() {
        levelViews.enumerated().forEach { index, view in
            if index == levelViews.count - 1 {
                return
            }
            
            let path = UIBezierPath()
            path.move(to: view.center)
            path.addLine(to: levelViews[index + 1].center)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.lineWidth = 10
            layer.lineDashPattern = [20, 10]
            layer.strokeColor = levels[index + 1].isLocked ? UIColor.gray.cgColor : UIColor(hex: "#FF6602").cgColor
        
            scrollView.layer.insertSublayer(layer, below: view.layer)
        }
    }
    
    @objc private func levelDidTapped(_ sender: UITapGestureRecognizer) {
        if let view = sender.view as? LevelView,
           let text = view.number.text,
           let number = Int(text) {
            
            if levels[number-1].isLocked {
                let controller = UIAlertController(title: "", message: "Complete previous levels to unlock this one.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in }
                controller.addAction(action)
                present(controller, animated:  true)
            } else {
                MainRouter.shared.showDetailLevelScreen(id: number)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        MainRouter.shared.pop(animated: true)
    }
}
