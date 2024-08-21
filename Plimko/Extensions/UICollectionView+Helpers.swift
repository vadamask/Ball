import UIKit

extension UICollectionView {
    func register<CellClass: UICollectionViewCell>(_ cellClass: CellClass.Type) {
        register(cell: cellClass.self, forCellReuseIdentifier: cellClass.identifier)
    }

    func register<Cell>(cell: Cell.Type, forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeue<Cell>(_ reusableCell: Cell.Type, indexPath: IndexPath) -> Cell? where Cell: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: reusableCell.identifier, for: indexPath) as? Cell
    }
    
    func configureCell(for item: CollectionViewItem, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeue(item.cellType, for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.configure(with: item, indexPath: indexPath)
        }
        return cell
    }
    
    func dequeue<CellClass: UICollectionViewCell>(_ cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        let identifier = String(describing: cellClass.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CellClass else {
            fatalError("Could not deque cell with type \(cellClass.self)")
        }
        return cell
    }
    
    func register<ReusableView: UICollectionReusableView>(viewClass: ReusableView.Type, identifier: String = ReusableView.identifier, kind: String) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func dequeue<ReusableView: UICollectionReusableView>(_ view: ReusableView.Type, kind: String, id: String = ReusableView.identifier, for indexPath: IndexPath) -> ReusableView {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? ReusableView
        else { fatalError("Could not deque cell with type \(view.self)") }
        
        return view
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

protocol CollectionViewCell {
    func configure(with item: CollectionViewItem, indexPath: IndexPath)
}

protocol CollectionViewItem {
    var cellHeight: CGFloat { get }
    var cellType: (UICollectionViewCell & CollectionViewCell).Type { get }
}

extension CollectionViewItem {
    var cellHeight: CGFloat {
        return UITableView.automaticDimension
    }
}
