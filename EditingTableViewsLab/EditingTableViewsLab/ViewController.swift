//
//  ViewController.swift
//  EditingTableViewsLab
//
//  Created by Anthony Gonzalez on 8/16/19.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var shoppingItems = [ShoppingItem]()
    
    var addedShoppingItems  = [ShoppingItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toggleEditMode: UIButton!
    
    
    @IBAction func toggleEditMode(_ sender: UIButton) {
        switch tableView.isEditing {
        case true:
            tableView.setEditing(false, animated: true)
            sender.setTitle("Edit", for: .normal)
        case false:
            tableView.setEditing(true, animated: false)
            sender.setTitle("Done", for: .normal)
        }
    }
    
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        guard let addItemVC =  segue.source as? AddItemViewController else {fatalError()}
        guard let itemName = addItemVC.nameTextField.text, let price = addItemVC.priceTextField.text, let priceAsDouble = Double(price) else {fatalError()}
        let newItem = ShoppingItem(name: itemName, price: priceAsDouble)
        let lastIndex = tableView.numberOfRows(inSection: 0)
        let lastIndexPath = IndexPath(row: lastIndex, section: 0)
        addedShoppingItems.append(newItem)
        tableView.insertRows(at: [lastIndexPath], with: .automatic)
    }
    
    private func loadShoppingItems() {
        let allItems = ShoppingItemFetchingClient.getShoppingItems()
        shoppingItems = allItems
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShoppingItems()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addedShoppingItems.count
        } else {
            return shoppingItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        if indexPath.section == 0 {
            let shoppingItem = addedShoppingItems[indexPath.row]
            cell.textLabel?.text = shoppingItem.name
            cell.detailTextLabel?.text = "$\(shoppingItem.price)"
        } else {
            let shoppingItem = shoppingItems[indexPath.row]
            cell.textLabel?.text = shoppingItem.name
            cell.detailTextLabel?.text = "$\(shoppingItem.price)"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Purchased Items"
        } else {
            return "Unpurchased Items"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch editingStyle {
            case .delete:
                addedShoppingItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default: break
            }
        } else {
            switch editingStyle {
            case .delete:
                shoppingItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let lastItem = addedShoppingItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            shoppingItems.append(lastItem)
            let lastIndex = tableView.numberOfRows(inSection: 1)
            let lastIndexPath = IndexPath(row: lastIndex, section: 1)
            tableView.insertRows(at: [lastIndexPath], with: .automatic)
        } else {
            let lastItem = shoppingItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            addedShoppingItems.append(lastItem)
            let lastIndex = tableView.numberOfRows(inSection: 0)
            let lastIndexPath = IndexPath(row: lastIndex, section: 0)
            tableView.insertRows(at: [lastIndexPath], with: .automatic)
            
        }
    }
}


