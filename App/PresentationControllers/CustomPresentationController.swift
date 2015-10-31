//
//  Created by Pete Callaway on 26/06/2014.
//  Copyright (c) 2014 Dative Studios. All rights reserved.
//

import UIKit


class CustomPresentationController: UIPresentationController {

    lazy var dimmingView: UIVisualEffectView = {
        return UIVisualEffectView(frame: self.containerView!.bounds)
    }()

    override func presentationTransitionWillBegin() {

		guard
			let containerView = containerView,
			let presentedView = presentedView()
		else {
			return
		}

        // Add the dimming view and the presented view to the heirarchy
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedView)

        // Set the effect on the visual effect view inside the animation block 
        // causes it to animate in (https://forums.developer.apple.com/thread/4140)
        // Do this alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.effect = UIBlurEffect(style: .Light)
            }, completion:nil)
        }
    }

    override func presentationTransitionDidEnd(completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin()  {
        // Remove the effect alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.effect = nil
            }, completion:nil)
        }
    }

    override func dismissalTransitionDidEnd(completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {

		guard
			let containerView = containerView
		else {
			return CGRect()
		}

        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = containerView.bounds;
        frame = CGRectInset(frame, 50.0, 50.0)

        return frame
    }


    // ---- UIContentContainer protocol methods

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)

		guard
			let containerView = containerView
		else {
			return
		}

        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.frame = containerView.bounds
        }, completion:nil)
    }
}
