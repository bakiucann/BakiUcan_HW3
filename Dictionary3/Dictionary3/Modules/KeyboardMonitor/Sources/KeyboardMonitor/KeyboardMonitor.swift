import UIKit

public class KeyboardMonitor {
    // MARK: - Properties
    public private(set) var isKeyboardVisible = false

    // MARK: - Initialization
    public init() {
        // Registering for keyboard show and hide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Keyboard Notifications
    @objc private func keyboardWillShow() {
        // Updating the keyboard visibility state when the keyboard will show
        isKeyboardVisible = true
    }

    @objc private func keyboardWillHide() {
        // Updating the keyboard visibility state when the keyboard will hide
        isKeyboardVisible = false
    }

    // MARK: - Deinitialization
    deinit {
        // Removing the observer for keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}
