 //
 //  ContainerVC.swift
 //  UberVietNam
 //
 //  Created by Nguyen Trung Kien on 10/13/18.
 //  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
 //
 
 import UIKit
 import QuartzCore
 
 enum SlideOutState {
    case collapsed
    case leftPanelExpanded
 }
 
 enum ShowWhichVC {
    case homeVC
 }
 
 var currentVC: ShowWhichVC = .homeVC
 
 class ContainerVC: UIViewController {
    
    let DUMMY_VIEW_COVER_TAG = 25
    
    var homeVC : HomeVC!
    var leftVC : LeftSidePanelVC!
    var centerController : UIViewController!
    var currentState : SlideOutState = .collapsed {
        didSet {
            shouldShowShadowForCenterVC(status: currentState != .collapsed)
        }
    }
    
    var isHidden = false
    let centerPanelExpandOffset : CGFloat = 160
    
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCenter(screen: currentVC)
    }
    
    func initCenter(screen: ShowWhichVC) {
        var presentingController : UIViewController?
        
        currentVC = screen
        
        if homeVC == nil {
            homeVC = UIStoryboard.homeVC()
            homeVC.delegate = self
        }
        
        presentingController = homeVC
        
        if let con = centerController {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        
        centerController = presentingController

        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
 }
 
 extension ContainerVC : CenterVCDelegate {
    
    func togglePanelLeft() {
        let notAlreadyExpanded = currentState != .leftPanelExpanded
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if leftVC == nil {
            leftVC = UIStoryboard.leftViewController()
            addChildSidePanelViewController(leftVC)
        }
    }
    
    @objc func animateLeftPanel(shouldExpand: Bool) {
        isHidden = !isHidden
        animateStatusBar()
        
        if shouldExpand {
            showWhiteCoverView()
            
            currentState = .leftPanelExpanded
            
            animateCenterPanelXposition(targetPosition: centerController.view.frame.width - centerPanelExpandOffset)
        } else {
            hideWhiteCoverView()
            
            animateCenterPanelXposition(targetPosition: 0) { (finished) in
                if finished {
                    self.currentState = .collapsed
                    self.leftVC = nil
                }
            }
        }
    }
    
    func showWhiteCoverView() {
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.tag = DUMMY_VIEW_COVER_TAG
        
        self.centerController.view.addSubview(whiteCoverView)
        
        UIView.animate(withDuration: 0.2) {
            whiteCoverView.alpha = 0.75
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)))
        tapGesture.numberOfTapsRequired = 1
        self.centerController.view.addGestureRecognizer(tapGesture)
    }
    
    func hideWhiteCoverView() {
        self.centerController.view.removeGestureRecognizer(tapGesture)
        
        for subView in self.centerController.view.subviews {
            if subView.tag == DUMMY_VIEW_COVER_TAG {
                UIView.animate(withDuration: 0.2, animations: {
                    subView.alpha = 0.0
                }) { (finished) in
                    if finished {
                        subView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func shouldShowShadowForCenterVC(status: Bool) {
        if status {
            self.centerController.view.layer.shadowOpacity = 0.6
        } else {
            self.centerController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func animateCenterPanelXposition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func addChildSidePanelViewController(_ sidePanelController: LeftSidePanelVC) {
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
 }
 
 private extension UIStoryboard {
    
    class func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftViewController() -> LeftSidePanelVC? {
        return mainStoryBoard().instantiateViewController(withIdentifier: "LeftSidePanelVC") as? LeftSidePanelVC
    }
    
    class func homeVC() -> HomeVC? {
        return mainStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
 }
