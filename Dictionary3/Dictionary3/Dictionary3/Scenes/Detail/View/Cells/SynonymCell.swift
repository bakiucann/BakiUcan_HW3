//
//  SynonymCell.swift
//  Dictionary3
//
//  Created by Baki Uçan on 27.05.2023.
//

import UIKit

class SynonymCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "SynonymCell"

    private var titleLabel: UILabel!
    private var synonymsStackView: UIStackView!

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Title Label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = "Synonyms"
        contentView.addSubview(titleLabel)

        // Synonyms Stack View
        synonymsStackView = UIStackView()
        synonymsStackView.translatesAutoresizingMaskIntoConstraints = false
        synonymsStackView.axis = .vertical
        synonymsStackView.spacing = 30
        synonymsStackView.alignment = .leading
        contentView.addSubview(synonymsStackView)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            synonymsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            synonymsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            synonymsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with synonyms: [String]) {
        // Hide the title label if synonyms array is empty
        titleLabel.isHidden = synonyms.isEmpty

        // Clear existing arranged subviews from the stack view
        synonymsStackView.arrangedSubviews.forEach { subview in
            synonymsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        // Add synonyms to the stack view
        var horizontalStackView: UIStackView? = nil
        for (index, synonym) in synonyms.enumerated() {
            // Create a new horizontal stack view for every 4 synonyms
            if index % 4 == 0 {
                horizontalStackView = UIStackView()
                horizontalStackView?.translatesAutoresizingMaskIntoConstraints = false
                horizontalStackView?.axis = .horizontal
                horizontalStackView?.spacing = 5
                horizontalStackView?.alignment = .leading
                synonymsStackView.addArrangedSubview(horizontalStackView!)
            }

            // Create a container view for each synonym label
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.widthAnchor.constraint(equalToConstant: 90).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 45).isActive = true

            // Synonym Label
            let label = UILabel()
            label.text = synonym
            label.layer.borderWidth = 0.3
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.cornerRadius = 18
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.textAlignment = .center
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false

            // Add label to the container view
            containerView.addSubview(label)

            // Constraints for the label within the container view
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
                label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
            ])

            // Add container view to the current horizontal stack view
            horizontalStackView?.addArrangedSubview(containerView)
        }
    }
}
