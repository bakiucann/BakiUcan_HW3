//
//  SearchViewController.swift
//  Dictionary3
//
//  Created by Baki Uçan on 26.05.2023.
//

import UIKit
import CoreData
import KeyboardMonitor

class SearchViewController: UIViewController {

    private var searchTextField: UITextField!
    private var searchButton: UIButton!
    private var recentSearchesTable: UITableView!
    private var viewModel: SearchViewModel!
    private var searchManager: SearchManager!
    private var keyboardMonitor = KeyboardMonitor()
    private var searchButtonBottomConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        searchManager = SearchManager()

        setupViews()
        layoutViews()
        startMonitoringKeyboard()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap))
           self.view.addGestureRecognizer(tapGesture)
    }

    private func setupViews() {
        searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.leftViewMode = .always
        searchTextField.autocorrectionType = .no

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let searchIconView = UIImageView(image: UIImage(named: "search"))
        searchIconView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.tintColor = .gray
        containerView.addSubview(searchIconView)
        containerView.addSubview(searchTextField)
        searchTextField.leftView = containerView

        searchTextField.layer.cornerRadius = 8
        searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchTextField.layer.shadowRadius = 4
        searchTextField.layer.shadowOpacity = 0.3
        searchTextField.layer.masksToBounds = false

        self.view.addSubview(searchTextField)

        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = UIColor.systemIndigo
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        self.view.addSubview(searchButton)

        recentSearchesTable = UITableView()
        recentSearchesTable.translatesAutoresizingMaskIntoConstraints = false
        recentSearchesTable.dataSource = self
        recentSearchesTable.delegate = self
        recentSearchesTable.separatorStyle = .none
        self.view.addSubview(recentSearchesTable)
      
    }

    private func layoutViews() {
      searchButtonBottomConstraint = searchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            recentSearchesTable.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            recentSearchesTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recentSearchesTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            recentSearchesTable.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -10),

            searchButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            searchButtonBottomConstraint,
            searchButton.heightAnchor.constraint(equalToConstant: 70)
        ])

        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.view.bringSubviewToFront(searchButton)
    }

  private func startMonitoringKeyboard() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc private func keyboardWillShow(notification: NSNotification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          let keyboardRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keyboardRectangle.height
          // Move Search Button right above the keyboard
          searchButtonBottomConstraint.constant = -keyboardHeight
          UIView.animate(withDuration: 0.25) {
              self.view.layoutIfNeeded()
          }
      }
  }

  @objc private func keyboardWillHide(notification: NSNotification) {
      // Move Search Button back to bottom when keyboard disappears
      searchButtonBottomConstraint.constant = 0
      UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
      }
  }


  @objc func handleScreenTap(sender: UITapGestureRecognizer) {
      if sender.state == .ended {
          // end editing and therefore resign first responder for text field
          view.endEditing(true)
      }
      sender.cancelsTouchesInView = false
  }


    @objc func searchButtonTapped() {
        guard let term = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !term.isEmpty, term.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil else {
            showAlert(message: "Please enter a valid search term")
            return
        }
        searchManager.addSearchTerm(term)
        recentSearchesTable.reloadData()

        let detailVC = DetailViewController()
        detailVC.searchTerm = term
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

  deinit {
          NotificationCenter.default.removeObserver(self)
      }


}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.getRecentSearches().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let searchIconView = UIImageView(image: UIImage(named: "search"))
        searchIconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.tintColor = .black

        let arrowIconView = UIImageView(image: UIImage(named: "right-arrow"))
        arrowIconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        arrowIconView.contentMode = .scaleAspectFit
        arrowIconView.tintColor = .black

        cell.imageView?.image = searchIconView.image
        cell.accessoryView = arrowIconView
        cell.textLabel?.text = searchManager.getRecentSearches()[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.searchTerm = searchManager.getRecentSearches()[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let titleLabel = UILabel()
        titleLabel.text = "Recent Search"
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -10)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
