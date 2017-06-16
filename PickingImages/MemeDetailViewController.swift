//
//  MemeDetailViewController.swift
//  PickingImages
//
//  Created by Erik Uecke on 6/13/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    var meme: Meme!
    
    // MARK: Outlet
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
