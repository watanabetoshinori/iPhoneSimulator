//
//  iPhoneSimulator.swift
//  iPhoneSimulator
//
//  Created by Watanabe Toshinori on 9/7/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class iPhoneSimulator: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var statusBarView: UIView!

    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var deviceView: UIView!

    @IBOutlet weak var deviceLabel: UILabel!

    @IBOutlet weak var deviceListView: UIView!
    
    @IBOutlet weak var deviceListBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var deviceButtons: [UIButton]!
    
    @IBOutlet weak var orientationPortraitButton: UIButton!

    @IBOutlet weak var orientationLandscapeButton: UIButton!

    // MARK: - Variables
    
    var viewController: UIViewController!

    var device: SimulatorDevice!
    
    var orientation: SimulatorOrientation = .portrait {
        didSet {
            orientationPortraitButton.isHidden = orientation != .portrait
            orientationLandscapeButton.isHidden = orientation != .landscape
        }
    }

    // MARK: - Running Simulator
    
    /***
     For iOS Simulator
     */
    public class func run(window: UIWindow, device: SimulatorDevice = .iPhone8) {
        guard let rootViewController = window.rootViewController else {
            fatalError("Missing rootViewController.")
        }
        
        let simulator = iPhoneSimulator.liveView(with: rootViewController, device: device)
        window.rootViewController = simulator
    }
    
    /***
     For Playground
     */
    public class func liveView(with viewController: UIViewController, device: SimulatorDevice = .iPhone8) -> iPhoneSimulator {
        let storyboard = UIStoryboard(name: "iPhoneSimulator", bundle: Bundle(for: iPhoneSimulator.self))
        guard let simulatorViewController = storyboard.instantiateInitialViewController() as? iPhoneSimulator else {
            fatalError("Failed to instantiate iPhoneSimulator from storyboard.")
        }
        simulatorViewController.viewController = viewController
        simulatorViewController.device = device
        simulatorViewController.preferredContentSize = CGSize(width: 768, height: 768)
        return simulatorViewController
    }
    
    // MARK: - Laytout subviews
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reload()
    }
    
    // MARK: - Navigation
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, segue.identifier) {
        case (let containerViewController, "ContainerViewController"?):
            containerViewController.addChild(viewController)
            containerViewController.view.addSubview(viewController.view)
            viewController.view.frame = containerViewController.view.frame
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func deviceTapped(_ sender: Any) {
        let isDeviceListShown = deviceListBottomConstraint.constant == 0

        if isDeviceListShown {
            hideDeviceList()
        } else {
            showDeviceList()
        }
    }
    
    @IBAction func deviceImageTapped(_ sender: UIButton) {
        device = SimulatorDevice(rawValue: sender.tag) ?? .iPhone8
        reload()
    }
    
    @IBAction func orientationTapped(_ sender: UIButton) {
        if orientation == .portrait {
            orientation = .landscape
        } else {
            orientation = .portrait
        }
        reload()
    }
    
    // MARK: - Reloading View layout
    
    private func reload() {
        let traitDescription = device.traitsDescription(with: orientation)
        deviceLabel.text = "View as: \(device.name) \(traitDescription)"
        
        // Resize app root view
        let deviceSize = device.size(with: orientation)
        containerWidthConstraint.constant = deviceSize.width
        containerHeightConstraint.constant = deviceSize.height
        
        // Update traits
        let deviceTraits = device.trait(with: orientation)
        children.forEach { (viewController) in
            viewController.children.forEach { (childViewController) in
                viewController.setOverrideTraitCollection(deviceTraits, forChild: childViewController)
            }
        }
        
        deviceButtons.forEach { (button) in
            button.tintColor = (button.tag == device.rawValue) ? UIColor(red: 48/255, green: 110/255, blue: 237/255, alpha: 1.0) : .black
        }
    }
    
    // MARK: - Managing DeviceList
    
    private func showDeviceList() {
        view.layoutIfNeeded()
        
        deviceListBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideDeviceList(_ completion: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        
        deviceListBottomConstraint.constant = 121
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
            
        }) { _ in
            completion?()
        }
    }

}
