//
//  AddItemViewController.swift
//  EditingTableViewsLab
//
//  Created by Anthony Gonzalez on 9/2/19.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
