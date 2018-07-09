//
//  NavigationController.swift
//  AppwiseCore
//
//  Created by David Jennes on 25/09/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

import UIKit

/// UINavigationController that passes calls for orientation and status bar to it's top
/// view controller.
open class NavigationController: UINavigationController {
	override open var shouldAutorotate: Bool {
		return topViewController?.shouldAutorotate ?? super.shouldAutorotate
	}

	override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
	}

	override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
	}

	override open var childViewControllerForStatusBarStyle: UIViewController? {
		return topViewController
	}

	override open var childViewControllerForStatusBarHidden: UIViewController? {
		return topViewController
	}
}
