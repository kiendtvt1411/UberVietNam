//
//  HomeVC.swift
//  UberVietNam
//
//  Created by Nguyen Trung Kien on 10/12/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit
import MapKit


class HomeVC: UIViewController, MKMapViewDelegate {
    
    // MARK: - Variables

    var delegate: CenterVCDelegate?
    
    
    // MARK: - UI Elements
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnAction: RoundedShadowButton!
    
    
    // MARK: - UI Events
    
    @IBAction func btnActionPressed(_ sender: RoundedShadowButton) {
        btnAction.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    @IBAction func buttonMenuPressed(_ sender: UIButton) {
        delegate?.togglePanelLeft()
    }
    
    
    // MARK: - Main methods of Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }


}

