//
//  ViewController.swift
//  MyMovies


import UIKit
import Toast_Swift

class LoginViewController: UIViewController {
    
    let dispatcher = NetworkingDispatcher(environment: Environment(name: "Production", host: Constant.AUTHENTICATION_HOSTNAME))
    
    lazy var appName: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "Avenir-Heavy", size: 25)
        name.textColor = .white
        name.textAlignment = .center
        name.addCharactersSpacing(spacing: 3, text: "MyMovies")
        return name
    }()
    
    lazy var iconLogo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFill
        logo.clipsToBounds = true
        logo.image = #imageLiteral(resourceName: "Icon-83.5")
        logo.layer.borderWidth = 1
        logo.layer.borderColor = UIColor.white.cgColor
        logo.layer.cornerRadius = 50
        return logo
    }()
    
    let dontHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = createAttributedString(firstString: "Don't have an account? ", secondString: "Sign in as guest")
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleSignInAsGuest), for: .touchUpInside)
        return button
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor.lightGray
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.lightGray
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 249, green: 82, blue: 132)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupInputFields()
        
        setupDismissKeyboard()
    }
    
    fileprivate func setupDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.mainColor()
        view.addSubview(dontHaveAnAccountButton)
        view.addSubview(logoContainerView)
        view.addSubview(iconLogo)
        view.addSubview(appName)
        
        dontHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height / 4)
        iconLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        iconLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appName.anchor(top: iconLogo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    private func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, logInButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
    }
    
    @objc private func handleSignInAsGuest() {
        // Handle log user in with guest account
        
        var style = ToastStyle()
        
        style.backgroundColor = .black
        
        style.messageNumberOfLines = 1
        
        style.titleAlignment = .center
        
        let center = self.view.center
        
        let getGuestSessionToken = CreateGuestSessionService()
        
        getGuestSessionToken.execute(in: dispatcher, completionHandler: { (guestToken) in
            // Start guest session
            
            let user = User()
            
            user.sessionType = .guestUser
            
            user.sessionId = guestToken
            
            user.username = "Guest"
            
            UserSessionController.shared.updateCurrentUser(user: user)
            
            NotificationCenter.default.post(name: NSNotification.Name("stateChanged"), object: nil)
            
        }) { (errorCode) in
            print(errorCode ?? 0)
            
            self.view.makeToast("Something wrong happened, please try later!", duration: 2, point: center, title: "Error", image: nil, style: style, completion: nil)
        }
        
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!
        if isFormValid {
            logInButton.backgroundColor = UIColor.movieTintColor()
            logInButton.isEnabled = true
        } else {
            logInButton.backgroundColor = UIColor.rgb(red: 249, green: 82, blue: 132)
            logInButton.isEnabled = false
        }
    }
    
    @objc private func handleLogIn() {
        
        self.view.endEditing(true)
        
        self.logInButton.isEnabled = false
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        var style = ToastStyle()
        
        style.backgroundColor = .black
        
        style.messageNumberOfLines = 1
        
        style.titleAlignment = .center
        
        let center = self.view.center
        
        
        let getRequestTokenService = CreateRequestTokenService()
        
        
        getRequestTokenService.execute(in: dispatcher, completionHandler: { (token) in
            
            let createSessionService = CreateSessionWithLoginService(username: email, password: password, requestToken: token)
            
            createSessionService.execute(in: self.dispatcher, completionHandler: { (requestToken) in
                
                // Start new session
                
                let createSession = CreateSessionService(requestToken: requestToken)
                
                createSession.execute(in: self.dispatcher, completionHandler: { (sessionId) in
                    let user = User()
                    
                    user.sessionId = sessionId
                    
                    user.sessionType = .imbdUser
                    
                    user.username = email
                    
                    UserSessionController.shared.updateCurrentUser(user: user)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("stateChanged"), object: nil)

                }, failureBlock: { (errorCode) in
                    self.view.makeToast("Something wrong happened!", duration: 2, point: center, title: "Error", image: nil, style: style, completion: nil)
                    
                    self.logInButton.isEnabled = true
                })
                
                
            }, failureBlock: { (errorCode) in
                if errorCode == 401 {
                    self.view.makeToast("Invalid username and/or password!", duration: 2, point: center, title: "Error", image: nil, style: style, completion: nil)
                    
                    self.logInButton.isEnabled = true
                }
            })
            
        }) { (errorCode) in
            // Handle error
            
            self.view.makeToast("Something wrong happened!", duration: 2, point: center, title: "Error", image: nil, style: style, completion: nil)
            
            self.logInButton.isEnabled = true
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private static func createAttributedString(firstString: String, secondString: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: secondString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.movieTintColor(), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        return attributedText
    }
}

