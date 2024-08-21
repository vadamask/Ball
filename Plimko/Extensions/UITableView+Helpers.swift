import UIKit

extension UITableViewCell {
    static var identifier: String { return String(describing: self.self) }
}

extension UITableView {
    func register<Cell>(cell: Cell.Type, forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func register<CellClass: UITableViewCell>(_ cellClass: CellClass.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeue<CellClass: UITableViewCell>(_ cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        let identifier = String(describing: cellClass.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CellClass else {
            fatalError("Could not dequeue cell with type \(cellClass.self)")
        }
        return cell
    }
}
