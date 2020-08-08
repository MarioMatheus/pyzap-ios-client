//
//  Models.swift
//  Pyzap
//
//  Created by Mario Matheus on 07/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import Foundation

struct ZapMessage {
    let sender: String
    let receiver: String
    let content: String
}

struct ZapUser {
    let name: String
    let messages: [ZapMessage]
}
