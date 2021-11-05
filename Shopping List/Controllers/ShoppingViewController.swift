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
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Новая покупка", message: "Добавить новую покупку", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = String(indexPath.row)
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
}
