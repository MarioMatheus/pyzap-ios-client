//
//  Models.swift
//  Pyzap
//
//  Created by Mario Matheus on 07/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import Foundation

class ZapMessage {
    var sender: String
    var receiver: String
    var content: String
    
    init(sender: String, receiver: String, content: String) {
        self.sender = sender
        self.receiver = receiver
        self.content = content
    }
}

class ZapUser {
    var name: String
    var messages: [ZapMessage]
    
    init(name: String, messages: [ZapMessage]) {
        self.name = name
        self.messages = messages
    }
}
