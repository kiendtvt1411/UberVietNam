//
//  CenterVCDelegate.swift
//  UberVietNam
//
//  Created by Nguyen Trung Kien on 10/13/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

protocol CenterVCDelegate {
    func togglePanelLeft()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
