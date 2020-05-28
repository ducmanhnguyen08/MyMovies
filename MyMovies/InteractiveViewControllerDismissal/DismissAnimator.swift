//
//  DismissAnimator.swift
//  MyMovies


import Foundation
import UIKit

class DismissAnimator: NSObject {
    
}

extension DismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let snapShot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else { return }
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        fromVC.view.isHidden = true
        
        // Notice unwrap
        containerView.insertSubview(snapShot, aboveSubview: toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapShot.center.y += UIScreen.main.bounds.height
        }) { (completed) in
            fromVC.view.isHidden = false
            snapShot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
