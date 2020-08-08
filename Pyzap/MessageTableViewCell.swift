//
//  MessageTableViewCell.swift
//  Pyzap
//
//  Created by Mario Matheus on 08/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    let bubbleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sender: UILabel = {
        let label = UILabel()
        label.text = "sender"
        label.textColor = .cyan
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mensagem: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let horario: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        label.text = dateFormatter.string(from: Date())
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var message: ZapMessage? {
        didSet {
            self.mensagem.text = message?.content
            self.sender.text = message?.sender
        }
    }
    
    lazy var rightAlignmentContraint = bubbleBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    lazy var leftAlignmentContraint = bubbleBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
    
    var alignmentRight = true {
        didSet {
            if alignmentRight {
                rightAlignmentContraint.isActive = true
                leftAlignmentContraint.isActive = false
            } else {
                leftAlignmentContraint.isActive = true
                rightAlignmentContraint.isActive = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        self.addSubview(bubbleBackground)
        bubbleBackground.addSubview(sender)
        bubbleBackground.addSubview(mensagem)
        bubbleBackground.addSubview(horario)
    }
    
    func setupConstraints() {
        
        rightAlignmentContraint.isActive = true
        
        NSLayoutConstraint.activate([
            bubbleBackground.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            bubbleBackground.widthAnchor.constraint(equalToConstant:
                UIScreen.main.bounds.width > 375 ? 400 : UIScreen.main.bounds.width/1.5
            ),
            bubbleBackground.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            
            sender.topAnchor.constraint(equalTo: bubbleBackground.topAnchor, constant: 3),
            sender.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -3),
            sender.leadingAnchor.constraint(equalTo: bubbleBackground.leadingAnchor, constant: 8),
            
            mensagem.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: 3),
            mensagem.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -8),
            mensagem.leadingAnchor.constraint(equalTo:  bubbleBackground.leadingAnchor, constant: 8),
            mensagem.bottomAnchor.constraint(equalTo: horario.topAnchor, constant: -3),
            
            horario.trailingAnchor.constraint(equalTo: bubbleBackground.trailingAnchor, constant: -3),
            horario.widthAnchor.constraint(equalToConstant: 30),
            horario.bottomAnchor.constraint(equalTo: bubbleBackground.bottomAnchor, constant: -3)
        ])
    }

}
