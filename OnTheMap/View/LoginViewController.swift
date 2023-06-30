import UIKit

let reachability = try? Reachability()

class LoginViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoggedIn: Bool = false
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(OTMClient.EndPoints.signUp.url)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(loggingIn: true)
        
        if reachability?.connection == .unavailable {
            // No internet connection
            let errorMessage = "You don't have an internet connection. Please connect to the internet and try again."
            Alert.basicAlert(title: "Login Failed", message: errorMessage, vc: self)
            setLoggingIn(loggingIn: false)
        }
        
        OTMClient.loginUser(username: emailTextField.text ?? "",
                            password: passwordTextField.text ?? "") { (sessionResponse, error) in
            DispatchQueue.main.async { [self] in
                setLoggingIn(loggingIn: false)
                
                if let error = error {
                    // Handle the error and display the login failure message
                    handleLoginError(error)
                    isLoggedIn = false
                    print(error)
                } else if sessionResponse != nil {
                    // Successful login
                    isLoggedIn = true
                    performSegue(withIdentifier: "completeLogin", sender: nil)
                } else {
                    // Login failed
                    isLoggedIn = false
                    // Handle the login failure, e.g., show an error message
                    let errorMessage = LoginError.otherError.errorMessage
                    Alert.basicAlert(title: "Login Failed", message: errorMessage, vc: self)
                }
            }
        }
    }
    
    func handleLoginError(_ error: Error) {
        var errorMessage = LoginError.otherError.errorMessage
        
        if let loginError = error as? LoginError {
            errorMessage = loginError.errorMessage
        } else if let decodingError = error as? DecodingError,
                  case let .keyNotFound(key, _) = decodingError,
                  key.stringValue == "account" {
            errorMessage = LoginError.incorrectCredentials.errorMessage
        }
        Alert.basicAlert(title: "Login Failed", message: errorMessage, vc: self)
    }
    
    func setLoggingIn(loggingIn: Bool) {
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    @objc func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    //test commit
}
