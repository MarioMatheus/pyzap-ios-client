//
//  MasterViewController.swift
//  Pyzap
//
//  Created by Mario Matheus on 07/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, ServerDelegate {
    
    var detailViewController: DetailViewController? = nil
    
    var friends: [ZapUser] = []
    var me: ZapUser? {
        didSet {
            self.navigationItem.title = "Conversas\(me == nil ? "" : " de \(me!.name)")"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureConnectionBarButton()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewZapFriend(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        requestConnection()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func configureConnectionBarButton() {
        let leftBarButton = me != nil
            ? UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopConnection))
            : UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(requestConnection))
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc
    func requestConnection() {
        ServerManager.shared.delegate = self
        DispatchQueue.global(qos: .utility).async {
            ServerManager.shared.setupNetworkCommunication()
            RunLoop.current.run()
        }
    }
    
    @objc
    func stopConnection() {
        let alert = UIAlertController(
            title: "Desconectar",
            message: "Tem certeza que deseja ficar offline? Você não poderá mais enviar ou receber mensagens",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) {
                ServerManager.shared.stopChatSession()
                self.me = nil
                self.configureConnectionBarButton()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openCompleted() {
        DispatchQueue.main.async { [weak self] in
            self?.requestUserName("Digite o apelido no qual vc será reconhecido no pychat") { name in
                if let data = name.data(using: .utf8) {
                    ServerManager.shared.send(data)
                    self?.me = ZapUser(name: name, messages: [])
                    self?.configureConnectionBarButton()
                }
            }
        }
    }
    
    func endEncountered() {
        print("End Encountered")
    }
    
    func errorOccurred() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Sem Conexão", message: """
                Houve um erro ao tentar se comunicar com o servidor, tente novamente mais tarde
            """, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func received(message: ZapMessage) {
        DispatchQueue.main.async { [weak self] in
            let friend = self?.friends.filter({ $0.name == message.sender }).first
            if let friend = friend {
                friend.messages.append(message)
            } else {
                self?.friends.insert(ZapUser(name: message.sender, messages: [message]), at: 0)
            }
            self?.detailViewController?.chatTableView.reloadData()
            self?.tableView.reloadData()
        }
    }
    
    func requestUserName(_ message: String, _ cancelButton: Bool = false, _ completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Apelido", message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "apelido"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) {
                if let nameText = alert.textFields?.first?.text, nameText != "" {
                    completion(nameText)
                } else {
                    self.requestUserName(message, cancelButton,completion)
                }
            }
        })
        
        if cancelButton {
            alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        }
        
        present(alert, animated: true, completion: nil)
    }

    @objc
    func insertNewZapFriend(_ sender: Any) {
        if me == nil { return }
        requestUserName("Digite o apelido de quem vc deseja conversar", true) { name in
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
                controller.contatosTableView = tableView
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

