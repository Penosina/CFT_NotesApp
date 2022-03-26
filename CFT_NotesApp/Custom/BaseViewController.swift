import UIKit

class BaseViewController: UIViewController {    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Public Methods
    func showAlert(text: String?) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: text ?? "", attributes: [
            .font : UIFont.systemFont(ofSize: Dimensions.standart)
        ]), forKey: Strings.alertKey)
        let okAction = UIAlertAction(title: Strings.ok, style: .default, handler: nil)
        alert.view.tintColor = .black
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: Error) {
        showAlert(text: error.localizedDescription)
    }
}

// MARK: - Strings
private extension Strings {
    static let ok = "Ок"
    static let alertKey = "attributedTitle"
}
