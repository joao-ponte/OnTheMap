import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoggedIn: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = "joao_ponte@msn.com"
        passwordTextField.text = "talude2011"
    }

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(loggingIn: true)
        
        OTMClient.loginUser(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (sessionResponse, error) in
            DispatchQueue.main.async {
                self.setLoggingIn(loggingIn: false)
                
                if let error = error {
                    // Handle the error and display the login failure message
                    let errorMessage = "Login failed. \(error.localizedDescription)"
                    self.showLoginFailure(message: errorMessage)
                    self.isLoggedIn = false
                } else if sessionResponse != nil {
                    // Successful login
                    self.isLoggedIn = true
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeLogin" {
            // Reset the text fields after successful login
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    func setLoggingIn(loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}


