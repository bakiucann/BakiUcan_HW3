//
//  SynonymCell.swift
//  Dictionary3
//
//  Created by Baki Uçan on 27.05.2023.
//

import UIKit

class SynonymCell: UITableViewCell {
    static let reuseIdentifier = "SynonymCell"

    private var titleLabel: UILabel!
    private var synonymsStackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = "Synonyms"
        contentView.addSubview(titleLabel)

        synonymsStackView = UIStackView()
        synonymsStackView.translatesAutoresizingMaskIntoConstraints = false
        synonymsStackView.axis = .vertical
        synonymsStackView.spacing = 30
        synonymsStackView.alignment = .leading
        contentView.addSubview(synonymsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            synonymsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            synonymsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            synonymsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with synonyms: [String]) {
        titleLabel.isHidden = synonyms.isEmpty

        for arrangedSubview in synonymsStackView.arrangedSubviews {
            synonymsStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }

        var horizontalStackView: UIStackView? = nil
        for (index, synonym) in synonyms.enumerated() {
            if index % 4 == 0 {
                horizontalStackView = UIStackView()
                horizontalStackView?.translatesAutoresizingMaskIntoConstraints = false
                horizontalStackView?.axis = .horizontal
                horizontalStackView?.spacing = 5
                horizontalStackView?.alignment = .leading
                synonymsStackView.addArrangedSubview(horizontalStackView!)
            }

            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 45).isActive = true

            let label = UILabel()
            label.text = synonym
            label.layer.borderWidth = 0.3
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.cornerRadius = 18
            label.textAlignment = .center
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false

            containerView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
                label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
            ])

            horizontalStackView?.addArrangedSubview(containerView)
        }
    }
}
