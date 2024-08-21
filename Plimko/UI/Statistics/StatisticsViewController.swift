import UIKit

final class StatisticsViewController: UIViewController {
    
    private var records: [Record]
    
    private let background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.detailLevel.rawValue)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let topLabel: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Label.stat.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let statBackground: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.bigFrame.rawValue)
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Moul-Regular", size: 35)
        label.text = "no records yet"
        return label
    }()
    
    init(id: Int) {
        records = LevelsService.shared.level(by: id).records.sorted()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        emptyLabel.isHidden = !records.isEmpty
    }
    
    private func setupUI() {
        
        tableView.dataSource = self
        tableView.register(RecordCell.self)
        
        view.addSubview(background)
        view.addSubview(statBackground)
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(emptyLabel)
        
        statBackground.insertSubview(tableView, belowSubview: topLabel)
        
        background.activateAnchors().equalToSuperview()
        
        topLabel
            .activateAnchors()
            .topAnchor(to: backButton.bottomAnchor, constant: 10)
            .centerXToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.9)
            .aspectRatio(width: 1, height: 4.2)
        
        statBackground
            .activateAnchors()
            .centerToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.9)
            .aspectRatio(width: 1.36, height: 1)
        
        backButton
            .activateAnchors()
            .topAnchor(to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .leadingAnchor(16)
            .dimensionAnchors(width: 50, height: 50)
        
        tableView
            .activateAnchors()
            .equalToSuperview(2)
        
        emptyLabel.activateAnchors().centerToSuperview()
    }
    
    @objc private func backButtonTapped() {
        MainRouter.shared.pop(animated: true)
    }
}

// MARK: - Table view data source

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RecordCell.self, for: indexPath)
        cell.backgroundColor = .clear
        cell.configure(with: records[indexPath.row], place: indexPath.row + 1)
        return cell
    }
}

