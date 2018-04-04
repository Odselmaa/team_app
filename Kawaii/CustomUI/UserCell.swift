//
//  UserCell.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/2/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//

import UIKit
import Hero

class UserCell: UITableViewCell {
  @IBOutlet weak var imageUserView: UIImageView!
  @IBOutlet weak var ivBorder: UIImageView!
    
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var groupLabel: UILabel!

  var user: User? {
    didSet {
      guard let user = user else { return }
      let id = user.id!

      nameLabel.text = "\(user.firstname) \(user.lastname)"
      nameLabel.heroID = "\(id)_name"
      nameLabel.heroModifiers = [.zPosition(4)]
      imageUserView.image = user.image
      imageUserView.heroID = "\(id)_image"
      imageUserView.heroModifiers = [.zPosition(2)]
      groupLabel.heroID = "\(id)_group"
      groupLabel.heroModifiers = [.zPosition(4)]
      groupLabel.text = user.group
      ivBorder.heroID = "\(id)_border"
      ivBorder.heroModifiers = [.zPosition(2)]
    }
  }
    override func draw(_ rect: CGRect) {
       imageUserView.asCircle()

    }
}


