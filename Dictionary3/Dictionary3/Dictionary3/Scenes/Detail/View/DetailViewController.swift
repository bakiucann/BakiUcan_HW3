//  DetailViewController.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    var searchTerm: String!
    private var detailTableView: UITableView!
    private var titleLabel: UILabel!
    private var phoneticLabel: UILabel!
    private var soundButton: UIButton!
    private var titleLabelContainer: UIView!
    private var viewModel: DetailViewModel!
    private var synonyms: [String] = []
    private var meanings: [Meaning] = []
    private var buttonsStackView: UIStackView!
    private var clearFilterButton: UIButton!
    private var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(searchTerm != nil, "Search term must be set before presenting DetailViewController.")

        let backButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton

        self.view.backgroundColor = .white
        viewModel = DetailViewModel()

        setupViews()
        layoutViews()

        titleLabel.text = searchTerm
        detailTableView.register(SynonymCell.self, forCellReuseIdentifier: SynonymCell.reuseIdentifier)

        viewModel.meanings.bind { [weak self] meanings in
            DispatchQueue.main.async {
                self?.meanings = meanings ?? []
                self?.detailTableView.reloadData()
            }
        }

        viewModel.synonyms.bind { [weak self] synonyms in
            DispatchQueue.main.async {
                self?.synonyms = synonyms ?? []
                self?.detailTableView.reloadData()
            }
        }

        viewModel.phoneticText.bind { [weak self] phoneticText in
            DispatchQueue.main.async {
                if let phoneticText = phoneticText {
                    self?.phoneticLabel.text = phoneticText
                }
            }
        }
        viewModel.getDetails(for: searchTerm)
        viewModel.getSynonyms(for: searchTerm)
    }

    private func setupViews() {
        titleLabelContainer = UIView()
        titleLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabelContainer.backgroundColor = .systemGray6
        self.view.addSubview(titleLabelContainer)

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabelContainer.addSubview(titleLabel)

        phoneticLabel = UILabel()
        phoneticLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneticLabel.textColor = .gray
        titleLabelContainer.addSubview(phoneticLabel)

        soundButton = UIButton()
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.setImage(UIImage(named: "pronaunciation"), for: .normal)
        soundButton.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
        titleLabelContainer.addSubview(soundButton)

        buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 10
        titleLabelContainer.addSubview(buttonsStackView)

        clearFilterButton = UIButton()
        clearFilterButton.translatesAutoresizingMaskIntoConstraints = false
        clearFilterButton.setTitle("X", for: .normal)
        clearFilterButton.setTitleColor(.black, for: .normal)
        clearFilterButton.layer.cornerRadius = 18
        clearFilterButton.layer.borderWidth = 1.0
        clearFilterButton.layer.borderColor = UIColor.clear.cgColor
        clearFilterButton.backgroundColor = .white
        clearFilterButton.isHidden = true
        clearFilterButton.addTarget(self, action: #selector(clearFilterTapped), for: .touchUpInside)
        buttonsStackView.insertArrangedSubview(clearFilterButton, at: 0)

        let nounButton = createButton(withTitle: "Noun")
        nounButton.addTarget(self, action: #selector(nounButtonTapped), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(nounButton)

        let verbButton = createButton(withTitle: "Verb")
        verbButton.addTarget(self, action: #selector(verbButtonTapped), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(verbButton)

        let adjectiveButton = createButton(withTitle: "Adjective")
        adjectiveButton.addTarget(self, action: #selector(adjectiveButtonTapped), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(adjectiveButton)

        detailTableView = UITableView()
        detailTableView.translatesAutoresizingMaskIntoConstraints = false
        detailTableView.dataSource = self
        detailTableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.reuseIdentifier)
        self.view.addSubview(detailTableView)
    }

    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .white
        return button
    }

    @objc func clearFilterTapped(button: UIButton) {
        resetButtonSelection()
        clearFilterButton.isHidden = true

        viewModel.meanings.bind { [weak self] meanings in
            DispatchQueue.main.async {
                self?.meanings = meanings ?? []
                self?.detailTableView.reloadData()
            }
        }

        detailTableView.reloadData()
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func nounButtonTapped(button: UIButton) {
        resetButtonSelection()
        button.isSelected = !button.isSelected
        button.layer.borderColor = button.isSelected ? UIColor.systemIndigo.cgColor : UIColor.clear.cgColor
        clearFilterButton.isHidden = !button.isSelected
        filterMeanings(by: "noun")
    }

    @objc func verbButtonTapped(button: UIButton) {
        resetButtonSelection()
        button.isSelected = !button.isSelected
        button.layer.borderColor = button.isSelected ? UIColor.systemIndigo.cgColor : UIColor.clear.cgColor
        clearFilterButton.isHidden = !button.isSelected
        filterMeanings(by: "verb")
    }

    @objc func adjectiveButtonTapped(button: UIButton) {
        resetButtonSelection()
        button.isSelected = !button.isSelected
        button.layer.borderColor = button.isSelected ? UIColor.systemIndigo.cgColor : UIColor.clear.cgColor
        clearFilterButton.isHidden = !button.isSelected
        filterMeanings(by: "adjective")
    }

    @objc func soundButtonTapped() {
        guard let urlString = viewModel.phoneticAudioURLs.value?.first, let url = URL(string: urlString) else {
            print("No audio URL available")
            return
        }

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }

    private func filterMeanings(by partOfSpeech: String) {
        viewModel.meanings.bind { [weak self] meanings in
            DispatchQueue.main.async {
                self?.meanings = meanings?.filter { $0.partOfSpeech.lowercased() == partOfSpeech } ?? []
                self?.detailTableView.reloadData()
            }
        }
    }

    private func resetButtonSelection() {
        buttonsStackView.arrangedSubviews.forEach { (view) in
            if let button = view as? UIButton {
                button.isSelected = false
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
        clearFilterButton.isHidden = true
    }

  private func layoutViews() {
      NSLayoutConstraint.activate([
          titleLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          titleLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          titleLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

          titleLabel.topAnchor.constraint(equalTo: titleLabelContainer.topAnchor, constant: 20),
          titleLabel.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 20),

          soundButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
          soundButton.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -20),
          soundButton.widthAnchor.constraint(equalToConstant: 100),
          soundButton.heightAnchor.constraint(equalToConstant: 100),

          phoneticLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
          phoneticLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
          phoneticLabel.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor),

          buttonsStackView.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 10),
          buttonsStackView.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 20),
          buttonsStackView.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -20),
          buttonsStackView.bottomAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor, constant: -20), // Fix for buttonsStackView

          detailTableView.topAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor),
          detailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          detailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }

    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return meanings.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < meanings.count {
            return meanings[section].definitions.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < meanings.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseIdentifier, for: indexPath) as! DetailCell
            let meaning = meanings[indexPath.section]
            let definition = meaning.definitions[indexPath.row]
            cell.configure(with: definition, partOfSpeech: meaning.partOfSpeech, number: indexPath.row + 1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SynonymCell.reuseIdentifier, for: indexPath) as! SynonymCell
            cell.configure(with: synonyms)
            return cell
        }
    }
}
