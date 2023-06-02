import UIKit

public protocol Alertable {}

public extension Alertable where Self: UIViewController {
    // MARK: - Alert Presentation
    func showAlert(title: String = "Error", message: String, buttonTitle: String = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
