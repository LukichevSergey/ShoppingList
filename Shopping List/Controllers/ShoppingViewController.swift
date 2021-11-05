//
//  ShoppingViewController.swift
//  Shopping List
//
//  Created by Сергей Лукичев on 05.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class ShoppingViewController: UIViewController {
    
    private var user: User!
    private var ref: DatabaseReference!
    private var shopListItems: [ShopListItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        self.user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("shopList")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            var _shopListItems: [ShopListItem] = []
            for item in snapshot.children {
                let shopListItem = ShopListItem(snapshot: item as! DataSnapshot)
                _shopListItems.append(shopListItem)
            }
            self?.shopListItems = _shopListItems
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = shopListItems[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let item = shopListItems[indexPath.row]
        let isCompleted = !item.completed
        toggleCompletion(cell, isCompleted: isCompleted)
        item.ref?.updateChildValues(["completed" : isCompleted])
    }
    
    private func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Новая покупка", message: "Добавить новую покупку", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            let shopListItem = ShopListItem(title: textField.text!, userId: (self?.user.uid)!)
            let shopListItemRef = self?.ref.child(shopListItem.title.lowercased())
            shopListItemRef?.setValue(shopListItem.convertToDictionary())
        })
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        //Закрытие экрана
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension ShoppingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = shopListItems[indexPath.row].title
        toggleCompletion(cell, isCompleted: shopListItems[indexPath.row].completed)
        
        return cell
    }
    
}
