//
//  DetailViewController.swift
//  Pyzap
//
//  Created by Mario Matheus on 07/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var user: ZapUser?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func configureView() {
        chatTableView.dataSource = self
        chatTableView.backgroundColor = .clear
        messageTextField.autocorrectionType = .no
        chatTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    @IBAction func sendButtonDidPressed(_ sender: Any) {
        print("Send Button Did Pressed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.message = user?.messages[indexPath.row]
        return cell
    }
    
}
