//
//  MasterViewController.swift
//  Pyzap
//
//  Created by Mario Matheus on 07/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var me = ZapUser(name: "Mario", messages: [])
    
    var friends: [ZapUser] = [
        ZapUser(name: "Foo", messages: [
            ZapMessage(sender: "Foo", receiver: "Mario", content: "hey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listenhey listen"),
            ZapMessage(sender: "Foo", receiver: "Mario", content: "iaiiii meu boy")
        ]),
        ZapUser(name: "Bar", messages: [])
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewZapFriend(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        requestUserName("Digite o apelido no qual vc será reconhecido no pychat") { name in
            self.me = ZapUser(name: name, messages: [])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func requestUserName(_ message: String, _ completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Apelido", message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "apelido"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) {
                if let nameText = alert.textFields?.first?.text, nameText != "" {
                    completion(nameText)
                } else {
                    self.requestUserName(message, completion)
                }
            }
        })
        
        present(alert, animated: true, completion: nil)
    }

    @objc
    func insertNewZapFriend(_ sender: Any) {
        requestUserName("Digite o apelido de quem vc deseja conversar") { name in
            self.friends.insert(ZapUser(name: name, messages: []), at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let friend = friends[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.me = me
                controller.friend = friend
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = friends[indexPath.row]
        cell.detailTextLabel!.text = friend.messages.isEmpty ? "Sem mensagens" : friend.messages.last?.content
        cell.textLabel!.text = friend.name
        return cell
    }

//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            users.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}

