import UIKit

final class RecordCell: UITableViewCell {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Moul-Regular", size: 20)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recordLabel.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with record: Record, place: Int) {
        recordLabel.text = "\(place). Name: \(record.player.name), record: \(record.time)s, date: \(dateFormatter.string(from: record.date))"
        if record.player.id == 0 {
            recordLabel.textColor = .red
        }
    }
    
    private func setupUI() {
        contentView.addSubview(recordLabel)
        recordLabel
            .activateAnchors()
            .leadingAnchor(30)
            .trailingAnchor(-20)
            .topAnchor(10)
            .bottomAnchor(-10)
    }
}
