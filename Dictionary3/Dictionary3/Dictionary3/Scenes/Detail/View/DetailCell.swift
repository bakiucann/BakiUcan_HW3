//
//  DetailCell.swift
//  Dictionary3
//
//  Created by Baki Uçan on 28.05.2023.
//

import UIKit

class DetailCell: UITableViewCell {
    static let reuseIdentifier = "DetailCell"

    private var stackView: UIStackView!
    private var numberLabel: UILabel!
    private var definitionLabel: UILabel!
  

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        contentView.addSubview(stackView)

        numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = .black
        numberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stackView.addArrangedSubview(numberLabel)

        definitionLabel = UILabel()
        definitionLabel.translatesAutoresizingMaskIntoConstraints = false
        definitionLabel.textColor = .black
        definitionLabel.numberOfLines = 0
        stackView.addArrangedSubview(definitionLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

  func configure(with definition: Definition, partOfSpeech: String, number: Int) {
      let partOfSpeechTitle = partOfSpeech.capitalized

      let numberAttributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: UIColor.black
      ]
      let numberAttributedString = NSAttributedString(string: "\(number) - ", attributes: numberAttributes)

      let partOfSpeechAttributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: UIColor.blue,
          .font: UIFont.italicSystemFont(ofSize: 20)
      ]
      let partOfSpeechAttributedString = NSAttributedString(string: partOfSpeechTitle, attributes: partOfSpeechAttributes)

      let attributedString = NSMutableAttributedString()
      attributedString.append(numberAttributedString)
      attributedString.append(partOfSpeechAttributedString)

      attributedString.append(NSAttributedString(string: "\n\n")) // İki satır arası boşluk

      let definitionAttributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: UIColor.black,
          .font: UIFont.systemFont(ofSize: 14)
      ]
      let definitionAttributedString = NSAttributedString(string: "\(definition.definition)", attributes: definitionAttributes)

      attributedString.append(definitionAttributedString)

      if let example = definition.example {
          let exampleTitleAttributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: UIColor.black, // Example başlığının rengi
              .font: UIFont.boldSystemFont(ofSize: 14) // Change the font as desired
          ]
          let exampleTitleAttributedString = NSAttributedString(string: "\n\nExample  ", attributes: exampleTitleAttributes)

          let exampleAttributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: UIColor.gray, // Example içeriğinin rengi
              .font: UIFont.systemFont(ofSize: 14) // Change the font as desired
          ]
          let exampleAttributedString = NSAttributedString(string: "\n\n\(example)", attributes: exampleAttributes)

          attributedString.append(exampleTitleAttributedString)
          attributedString.append(exampleAttributedString)
      }

      definitionLabel.attributedText = attributedString
  }

}
