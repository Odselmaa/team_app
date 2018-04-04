//
//  CurrentUserController.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/2/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//
import UIKit
import Hero

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class CurrentUserController: UIViewController {
    var user:User?
    var panGR: UIPanGestureRecognizer!
    
    let db = KawaiiDB.getInstance()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ivBorder: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.asCircle()

        panGR = UIPanGestureRecognizer(target: self,
                                       action: #selector(handlePan(gestureRecognizer:)))
        
        view.addGestureRecognizer(panGR)
        
        if let user = user {
            let id = user.id!
            nameLabel.text = "\(user.firstname) \(user.lastname)"
            nameLabel.heroID = "\(id)_name"
            nameLabel.heroModifiers = [.zPosition(4)]
            imageView.image = user.image
            imageView.heroID = "\(id)_image"
            imageView.heroModifiers = [.zPosition(2)]
            descriptionLabel.heroID = "\(id)_description"
            descriptionLabel.heroModifiers = [.zPosition(4)]
            descriptionLabel.text = user.description
            groupLabel.heroID = "\(id)_group"
            groupLabel.heroModifiers = [.zPosition(4)]
            groupLabel.text = user.group
            ivBorder.heroID = "\(id)_border"
            ivBorder.heroModifiers = [.zPosition(2)]
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name:NSNotification.Name(rawValue: "refresh_user"), object: nil)
  }

    override func viewDidAppear(_ animated: Bool) {
        imageView.asCircle()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddUserController {
            vc.update_needed = true
            vc.user = user
        }
    }
    
    @objc func refreshUser(notification: NSNotification){
        user = db.getUser(user!.id!)
        if let user = user {
            let name = user.firstname
            nameLabel.text = name
            imageView.image = user.image
            descriptionLabel.text = user.description
            groupLabel.text = user.group
        }
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        
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
            Hero.shared.apply(modifiers: [.position(translation + ivBorder.center)], to: ivBorder)

            Hero.shared.apply(modifiers: [.position(translation + imageView.center)], to: imageView)
            Hero.shared.apply(modifiers: [.position(translation + nameLabel.center)], to: nameLabel)
        default:
            // end the transition when user ended their touch
            if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}
