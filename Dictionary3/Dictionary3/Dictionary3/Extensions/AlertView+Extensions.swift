//
//  Alert.swift
//  Dictionary3
//
//  Created by Baki Uçan on 27.05.2023.
//

import UIKit

extension SearchViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

