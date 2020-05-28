//
//  OnBoardingViewController.swift
//  MyMovies

import Foundation
import Lottie
import UIKit

class OnBoardingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "celliD"
    
    let onBoardingPages: [OnboardingPage] = {
        let firstPage = OnboardingPage(title: "Easy To Use", subtitle: "With only one click, you can easily save the TV shows or movies to your favourite list. Life never become easier!", animationName: "done")
        let secondPage = OnboardingPage(title: "Enjoy the film", subtitle: "Everything is now in your hand. Are you ready to explore it?", animationName: "enjoy")
        return [firstPage, secondPage]
    }()
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 2
        control.pageIndicatorTintColor = UIColor.onBoardText()
        control.currentPageIndicatorTintColor = UIColor.pageControlTintColor()
        control.currentPage = 0
        return control
    }()
    
    let skipBtn: OnBoaringButton = {
        let button = OnBoaringButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.borderWidth = 0.5
        button.isSelected = false
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(handleNextBtnClick), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        setupCollectionView()
        
        setupView()
    }
    
    //MARK: CollecttionView config
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OnBoardingCell
        cell.onboardingPage = onBoardingPages[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: Setup's method
    
    fileprivate func setupCollectionView() {
        collectionView?.register(OnBoardingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.mainColor()
        collectionView?.showsHorizontalScrollIndicator = false
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc fileprivate func handleNextBtnClick() {
        
        if pageControl.currentPage != (onBoardingPages.count - 1) {
            let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage += 1
            updateSkipBtn(pageNumber: pageControl.currentPage + 1)
        } else {
            
            let loginVC = LoginViewController()
            
            self.navigationController?.pushViewController(loginVC, animated: true)
            
            print(123)
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        
        print(pageNumber)
        
        updateSkipBtn(pageNumber: pageNumber)
    }
    
    fileprivate func setupView() {
        collectionView?.addSubview(skipBtn)
        collectionView?.addSubview(pageControl)
        
        pageControl.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: view.bounds.height / 4 - 30, paddingRight: 10, width: 0, height: 30)
        skipBtn.anchor(top: pageControl.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 40)
        skipBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func updateSkipBtn(pageNumber: Int) {
        pageControl.currentPage = pageNumber
        
        if pageNumber == 0 {
            skipBtn.setTitle("Next", for: .normal)
        } else {
            skipBtn.setTitle("Yes, I do!", for: .normal)
        }
    }
}

