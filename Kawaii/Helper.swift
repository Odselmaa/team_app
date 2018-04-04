//
//  Helper.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/1/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//

import UIKit
import SQLite
import Hero
extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    // Converting UIImage to Blob for storing in db
    public class func fromDatatypeValue(_ blobValue: Blob) -> UIImage {
        return UIImage(data: Data.fromDatatypeValue(blobValue))!
    }
    
    // Converting Blob to UIImage to display
    public var datatypeValue: Blob {
        return UIImagePNGRepresentation(self)!.datatypeValue
    }
}


extension UIView{
    // makes view circle
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2.0;
        self.layer.masksToBounds = true
    }
    
    func makeBorder(width:CGFloat){
        self.layer.borderWidth = width
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func roundCorner(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func shadow(shadowOpacity: Float, shadowRadius: CGFloat, size:CGSize){
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
    }
}
