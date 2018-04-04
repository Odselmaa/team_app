//
//  AddUserController.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/2/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//
import Foundation
import UIKit
import Hero
class AddUserController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var panGR: UIPanGestureRecognizer!
    var user:User?
    var update_needed = false
    var picker:UIImagePickerController? = UIImagePickerController()
    var image_chosen = false
    let db = KawaiiDB.getInstance()

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var ivPickImage: UIImageView!
    @IBOutlet weak var lblFirstname: UITextField!
    @IBOutlet weak var lblLastname: UITextField!
    @IBOutlet weak var lblGroup: UITextField!
    @IBOutlet weak var lblDesc: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGR = UIPanGestureRecognizer(target: self,
                                       action: #selector(handlePan(gestureRecognizer:)))
        
        view.addGestureRecognizer(panGR)
        picker?.delegate = self
        
        if update_needed, let u = user{
            ivPickImage.image = u.image
            lblFirstname.text = u.firstname
            lblLastname.text = u.lastname
            lblGroup.text = u.group
            lblDesc.text = u.description
            btnSave.titleLabel?.text = "UPDATE"
        }else{
            btnSave.titleLabel?.text = "SAVE"

        }
        print(update_needed)

    }
    override func viewWillAppear(_ animated: Bool) {

        btnSave.makeBorder(width: 2)
        btnSave.roundCorner(radius: 20)
        ivPickImage.asCircle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //update_needed = false
    }


    @objc func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        switch panGR.state {
        case .began:
            // begin the transition as normal
            dismiss(animated: true, completion: nil)
        case .changed:
            // calculate the progress based on how far the user moved
            
            Hero.shared.update(progress)

        default:
            // end the transition when user ended their touch
            if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivPickImage.image = chosenImage
        dismiss(animated: true, completion: nil)
        print("update need : \(update_needed)")
    }
    
    @IBAction func didTapPick(_ sender: Any) {
        openGallery()
    }
    
    
    @IBAction func didTapExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        let firstname = lblFirstname.text
        let lastname = lblLastname.text
        let group = lblGroup.text
        let desc = lblDesc.text
        let image = ivPickImage.image
        if lastname!.isEmpty || firstname!.isEmpty || group!.isEmpty || desc!.isEmpty {
            print("Form data is empty")
            lblWarning.isHidden = false
        }else{
            lblWarning.isHidden = true
            if(update_needed){
                self.user?.firstname = firstname!
                self.user?.lastname = lastname!
                self.user?.group = group!
                self.user?.description = desc!
                self.user?.image = image!
                print("user id \( user!.id!) " )
                db.updateUser(self.user!)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_user"), object: nil, userInfo: nil)
            }else{
                let u:User =  User(
                    firstname: firstname!,
                    lastname: lastname!,
                    image: image!,
                    group: group!,
                    desc: desc!
                )
                saveUser(u)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_users"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openGallery()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    func saveUser(_ user: User){
        let id = db.addUser(user: user)
        print(id!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
