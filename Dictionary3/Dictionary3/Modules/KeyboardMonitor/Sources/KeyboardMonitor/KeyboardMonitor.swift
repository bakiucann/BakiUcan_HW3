import UIKit

public class KeyboardMonitor {
    public private(set) var isKeyboardVisible = false

    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow() {
        isKeyboardVisible = true
    }

    @objc private func keyboardWillHide() {
        isKeyboardVisible = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

