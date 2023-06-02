// DetailViewController.swift
// Dictionary3
//
// Created by Baki Uçan on 26.05.2023.
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
    private var player: AVPlayer?
    private var buttonsScrollView: UIScrollView!
    private var clearButton: UIButton!
    private var selectedPartsOfSpeech: Set<String> = []


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

        viewModel.phoneticAudioURLs.bind { [weak self] audioURLs in
            DispatchQueue.main.async {
                if let audioURLs = audioURLs, !audioURLs.isEmpty {
                    self?.soundButton.isHidden = false
                } else {
                    self?.soundButton.isHidden = true
                }
            }
        }

        viewModel.meanings.bind { [weak self] meanings in
            DispatchQueue.main.async {
                self?.meanings = meanings ?? []
                self?.buttonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                var uniquePartOfSpeeches = Set<String>()
                for meaning in self?.meanings ?? [] {
                    uniquePartOfSpeeches.insert(meaning.partOfSpeech)
                }
                for partOfSpeech in uniquePartOfSpeeches {
                    let button = self?.createButton(withTitle: partOfSpeech)
                    button?.addTarget(self, action: #selector(self?.partOfSpeechButtonTapped(_:)), for: .touchUpInside)
                    self?.buttonsStackView.addArrangedSubview(button!)
                }
                self?.detailTableView.reloadData()
            }
        }

        viewModel.getDetails(for: searchTerm)
        viewModel.getSynonyms(for: searchTerm)
        clearButton.isHidden = true

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
        titleLabel.numberOfLines = 0
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

        buttonsScrollView = UIScrollView()
        buttonsScrollView.translatesAutoresizingMaskIntoConstraints = false
        titleLabelContainer.addSubview(buttonsScrollView)

        buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillProportionally
        buttonsStackView.spacing = 10
        buttonsScrollView.addSubview(buttonsStackView)

        clearButton = UIButton()
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(named: "xbutton"), for: .normal)
        clearButton.tintColor = .black
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        titleLabelContainer.addSubview(clearButton)

        detailTableView = UITableView()
        detailTableView.translatesAutoresizingMaskIntoConstraints = false
        detailTableView.separatorStyle = .none
        detailTableView.dataSource = self
        detailTableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.reuseIdentifier)
        self.view.addSubview(detailTableView)
    }

    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        let formattedTitle = title.prefix(1).capitalized + title.dropFirst()
        button.setTitle(formattedTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return button
    }


  @objc func partOfSpeechButtonTapped(_ button: UIButton) {
      let partOfSpeech = button.titleLabel?.text?.lowercased() ?? ""
      if selectedPartsOfSpeech.contains(partOfSpeech) {
          selectedPartsOfSpeech.remove(partOfSpeech)
          button.isSelected = false
          button.layer.borderColor = UIColor.clear.cgColor
      } else {
          selectedPartsOfSpeech.insert(partOfSpeech)
          button.isSelected = true
          button.layer.borderColor = UIColor.systemIndigo.cgColor
      }
      viewModel.isFiltering = !selectedPartsOfSpeech.isEmpty
      filterMeanings()
      clearButton.isHidden = selectedPartsOfSpeech.isEmpty
  }


    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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

  @objc func clearButtonTapped() {
      selectedPartsOfSpeech.removeAll()
      resetButtonSelection()
      viewModel.isFiltering = false
      viewModel.getDetails(for: searchTerm)
      clearButton.isHidden = true
  }


  private func filterMeanings() {
      viewModel.meanings.bind { [weak self] meanings in
          DispatchQueue.main.async {
              if self?.viewModel.isFiltering == true {
                  self?.meanings = meanings?.filter { self?.selectedPartsOfSpeech.contains($0.partOfSpeech.lowercased()) ?? false } ?? []
              } else {
                  self?.meanings = meanings ?? []
              }
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
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            titleLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: titleLabelContainer.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleLabelContainer.trailingAnchor, constant: -20),

            soundButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            soundButton.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -20),
            soundButton.widthAnchor.constraint(equalToConstant: 100),
            soundButton.heightAnchor.constraint(equalToConstant: 100),

            phoneticLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            phoneticLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            phoneticLabel.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor),

            clearButton.centerYAnchor.constraint(equalTo: buttonsScrollView.centerYAnchor),
            clearButton.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 20),
            clearButton.widthAnchor.constraint(equalToConstant: 24),
            clearButton.heightAnchor.constraint(equalToConstant: 24),

            buttonsScrollView.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 10),
            buttonsScrollView.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 10),
            buttonsScrollView.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -20),
            buttonsScrollView.bottomAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor, constant: -20),

            buttonsStackView.topAnchor.constraint(equalTo: buttonsScrollView.topAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: buttonsScrollView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: buttonsScrollView.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: buttonsScrollView.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalTo: buttonsScrollView.heightAnchor),

            detailTableView.topAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor),
            detailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
