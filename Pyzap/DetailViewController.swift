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
    
    var me: ZapUser?
    var friend: ZapUser?
    
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
        if let me = me, let friend = friend {
            let zapMessage = ZapMessage(sender: me.name, receiver: friend.name, content: messageTextField?.text ?? "😐")
            me.messages.append(zapMessage)
            friend.messages.append(zapMessage)
            chatTableView.reloadData()
            chatTableView.scrollToRow(at: [0, friend.messages.count - 1], at: .top, animated: true)
            messageTextField.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.message = friend?.messages[indexPath.row]
        let isMe = cell.message?.sender == me?.name
        cell.alignmentRight = isMe
        cell.sender.textColor = isMe ? .yellow : .cyan
        return cell
    }
    
}
