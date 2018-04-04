//
//  User.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/2/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//

import UIKit
import Foundation
class User {
  var id: Int64?
  var firstname: String
  var lastname: String
  var image: UIImage
  var group: String
  var description: String

    init(_id:Int64, firstname:String, lastname:String, image:UIImage, group:String, desc:String) {
        self.id = _id

        self.firstname = firstname
        self.lastname = lastname
        self.image = image
        self.group = group
        self.description = desc
    }
    init(firstname:String, lastname:String, image:UIImage, group:String, desc:String) {
        self.id = -1
        self.firstname = firstname
        self.lastname = lastname
        self.image = image
        self.group = group
        self.description = desc
    }

}
