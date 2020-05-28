//
//  MZFRootContainerAnimatedTransitioning.swift
//  MyMovies


import Foundation
import UIKit

public protocol MZFRootContainerAnimatedTransitioning {
    func transitionDuration() -> TimeInterval
    func animateTransition(with transitionContext: MZFRootContainerTransitioningContext)
}
