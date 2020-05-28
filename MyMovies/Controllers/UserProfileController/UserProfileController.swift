//
//  UserProfileController.swift
//  MyMovies
//


import Foundation
import UIKit
import StoreKit
import SDWebImage
import Toast_Swift

extension UserProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            // First section cells
            
            let cell = tableView.dequeueReusableCell(withIdentifier: firstSectionCellID, for: indexPath) as! UserProfileFirstSectionCell
            cell.cellModel = firstSectionText[indexPath.item]
            return cell
            
        case 1:
            // Second section cells
            let cell = tableView.dequeueReusableCell(withIdentifier: secondSectionCellID, for: indexPath) as! UserProfileSecondSectionCell
            cell.textLbl.text = secondSectionText[indexPath.item]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.backgroundColor = .yellow
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
        
        var style = ToastStyle()
        
        style.backgroundColor = .black
        
        style.messageNumberOfLines = 1
        
        style.titleAlignment = .center
        
        let center = self.view.center
        
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                print("Favourites")
                if currentUser.sessionType == .imbdUser {
                    let vc = MyFavouriteViewController()
                    
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.view.makeToast("This feature is not supported in guest mode!", duration: 2, point: center, title: "Info", image: nil, style: style, completion: nil)
                }
            case 1:
                
                if currentUser.sessionType == .imbdUser {
                    let vc = MyRatingViewController()
                    
                    navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    self.view.makeToast("This feature is not supported in guest mode!", duration: 2, point: center, title: "Info", image: nil, style: style, completion: nil)
                }
                
            case 2:
                self.view.makeToast("This feature is not supported in guest mode!", duration: 2, point: center, title: "Info", image: nil, style: style, completion: nil)
               
            default:
                ()
            }
        case 1:
            // Handle click the second section
            switch indexPath.item {
            case 0:
                // Clear cache image
                print("Clear cache")
                
                SDImageCache.shared().clearMemory()
                SDImageCache.shared().clearDisk(onCompletion: {
                    
                    var style = ToastStyle()
                    
                    style.backgroundColor = .black
                    
                    style.messageNumberOfLines = 1
                    
                    style.titleAlignment = .center
                    
                    let center = self.view.center
                    
                    self.view.makeToast("Clear successfully", duration: 2, point: center, title: "Info", image: nil, style: style, completion: nil)
                })
                
            case 1:
                // Rate the app
                print("Rate the app")
                
                SKStoreReviewController.requestReview()
            case 2:
                // About the app
                
                let aboutTheAppVC = AboutTheAppVC()
                
                self.navigationController?.pushViewController(aboutTheAppVC, animated: true)
                
            default:
                ()
            }
        default:
            ()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

class UserProfileController: UIViewController {
    
    let cellID = "cellID"
    let firstSectionCellID = "firstSection"
    let secondSectionCellID = "secondSection"
    
    let firstSectionText = [UserProfileCellModel(icon: #imageLiteral(resourceName: "star"), text: "Favourites"), UserProfileCellModel(icon: #imageLiteral(resourceName: "feedback"), text: "My ratings"), UserProfileCellModel(icon: #imageLiteral(resourceName: "list"), text: "Watchlist")]
    let secondSectionText = ["Clear image cache", "Rate our app", "About the app"]

    let userProfileTitle: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.addCharactersSpacing(spacing: 5, text: "PROFILE")
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.userProfileTintColor()
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        return tb
    }()
    
    let headerView: UserProfileHeader = {
        let header = UserProfileHeader()
        
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupNavbar()
    }
   
    // MARK: Setup methods
    
    fileprivate func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.mainColor()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.register(UserProfileFirstSectionCell.self, forCellReuseIdentifier: firstSectionCellID)
        tableView.register(UserProfileSecondSectionCell.self, forCellReuseIdentifier: secondSectionCellID)
        
        positionTableViewHeader()
        
    }
    
    fileprivate func positionTableViewHeader() {
        tableView.tableHeaderView = headerView
        
        headerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        
        headerView.anchor(top: tableView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 250)
        
        guard let headerView = self.tableView.tableHeaderView  as? UserProfileHeader else { return }
        
        guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
        
        headerView.username = currentUser.username
        
        headerView.layoutIfNeeded()
        
        
    }
    
    fileprivate func setupNavbar() {
        navigationItem.titleView = userProfileTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

    }
    
    @objc fileprivate func handleLogout() {
        
        // TODO: Handle logout
        print("Handle Logout")
        
        let logoutAlert = UIAlertController(title: "Warning", message: "Are you sure that you want to log out?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (yesAction) in
            
            UserSessionController.shared.deleteCurrentUser()
            
            NotificationCenter.default.post(name: NSNotification.Name("stateChanged"), object: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (noAction) in
            
        }
        
        logoutAlert.addAction(yesAction)
        logoutAlert.addAction(noAction)
        
        present(logoutAlert, animated: true, completion: nil)
    }
}
















