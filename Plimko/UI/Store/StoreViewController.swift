import UIKit

final class StoreViewController: BaseViewController {
    
    enum Constants {
        static let perRow: CGFloat = 3
        static let leftInset: CGFloat = 30
        static let topInset: CGFloat = 50
        static let itemSpacing: CGFloat = 20
        static let lineSpacing: CGFloat = 10
    }
    
    private let skinsService = SkinsService.shared
    private let levelsService = LevelsService.shared
    private var skins: [Skin] = []
    
    private let storeLabel: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Label.store.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let skinsBackground: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.bigFrame.rawValue)
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    
    private let balance: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Icon.balance.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.back.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.back.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#FF9900")
        label.font = UIFont(name: "Moul-Regular", size: 25)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(
            top: Constants.topInset,
            left: Constants.leftInset,
            bottom: Constants.topInset,
            right: Constants.leftInset
        )
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        skins = skinsService.getSkins()
    }
    
    private func setupUI() {
        starsLabel.text = levelsService.starsCount.description
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SkinCell.self)
        
        view.addSubview(skinsBackground)
        view.addSubview(storeLabel)
        view.addSubview(balance)
        view.addSubview(backButton)
        
        skinsBackground.addSubview(collectionView)
        
        balance.addSubview(starsLabel)
        
        skinsBackground
            .activateAnchors()
            .leadingAnchor(20)
            .trailingAnchor(-20)
            .centerYToSuperview(20)
            .heightAnchor(to: view.heightAnchor, multiplier: 0.65)
        
        storeLabel
            .activateAnchors()
            .centerXToSuperview()
            .widthAnchor(to: view.widthAnchor, multiplier: 0.7)
            .aspectRatio(width: 1, height: 3)
            .bottomAnchor(to: skinsBackground.topAnchor, constant: 40)
        
        balance
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(to: storeLabel.topAnchor, constant: -5)
            .dimensionAnchors(width: 100, height: 50)
        
        backButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: skinsBackground.bottomAnchor, constant: -30)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
        
        starsLabel
            .activateAnchors()
            .centerYToSuperview()
            .leadingAnchor(4)
            .dimensionAnchors(width: 45, height: 45)
        
        collectionView
            .activateAnchors()
            .leadingAnchor()
            .trailingAnchor()
            .topAnchor(3)
            .bottomAnchor(-4)
    }
    
    @objc private func backButtonTapped() {
        MainRouter.shared.pop(animated: false)
    }
}

// MARK: - Collection view data

extension StoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SkinCell.self, for: indexPath)
        cell.configure(with: skins[indexPath.row])
        return cell
    }
}

// MARK: - Collection view layout

extension StoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = Constants.leftInset * 2 + Constants.itemSpacing * (Constants.perRow - 1)
        let width = collectionView.bounds.width - horizontalSpacing
        let cellWidth = width / Constants.perRow
        
        let verticalSpacing = Constants.topInset * 2 + Constants.lineSpacing * (Constants.perRow - 1)
        let heigth = collectionView.bounds.height - verticalSpacing
        let cellHeigth = heigth / Constants.perRow
        
        return CGSize(width: cellWidth, height: cellHeigth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.lineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.itemSpacing
    }
}

// MARK: - Collection view delegate

extension StoreViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let skin = skins[indexPath.row]
        if skin.isChoosen { return }
        
        if !skin.isBuyed {
            let stars = levelsService.starsCount
            if skin.price > stars {
                let controller = UIAlertController(title: "", message: "To buy a skin, complete levels and earn stars.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in }
                controller.addAction(action)
                present(controller, animated:  true)
            } else {
                let controller = UIAlertController(title: "", message: "Are you sure you want to buy this skin?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                    guard let self else { return }
                    skinsService.buySkin(id: skin.id)
                    levelsService.starsCount -= skin.price
                    starsLabel.text = levelsService.starsCount.description
                    skins = skinsService.getSkins()
                    collectionView.reloadData()
                }
                
                let noAction = UIAlertAction(title: "No", style: .cancel)
                controller.addAction(action)
                controller.addAction(noAction)
                present(controller, animated:  true)
            }
        } else {
            skinsService.setChoosen(skin.id)
            skins = skinsService.getSkins()
            collectionView.reloadData()
        }
    }
}

