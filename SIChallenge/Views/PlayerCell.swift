//
//  PlayerCell.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 16/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation
import UIKit

////////////////////////////////////////////////////////////////////////////////
// MARK: Types


/**
 *  PlayerCell Inherit UICollectionViewCell
 */
class PlayerCell:UICollectionViewCell {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties
    
    lazy var imageManager:ImageManager = { ImageManager.defaultManager }()
    
    var player:Player?  {
        didSet {
            self.presentData()
        }
    }
    var teamColor:String?  {
        didSet {
            if teamColor != nil {
                self.backgroundColor = UIColor(hexString: teamColor!)
            }
        }
    }
    var imageTask:NSURLSessionDataTask? {
        willSet {
            // Cancel any previews unfinished image task
            imageTask?.cancel()
        }
    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    
    @IBOutlet weak var personFirstName: UILabel?
    @IBOutlet weak var personLastName: UILabel?
    @IBOutlet weak var playerJerseyNumber: UILabel?
    @IBOutlet weak var personAvatar: UIImageView?

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.teamColor = "008800"
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Override Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    
    private func presentData(){
        self.personFirstName?.text = self.player?.person?.firstName
        self.personLastName?.text = self.player?.person?.lastName
        self.playerJerseyNumber?.text = self.player?.jerseyNumber
        
        self.personAvatar?.image = UIImage(named: "avatarPlaceholder")
        if let person = self.player!.person  {
            if let urlStr = person.imageUrl  {
                
                self.imageTask = self.imageManager.imageFrom(NSURL(string:urlStr)!,
                                                                 transform:AvatarTransform(size: (self.personAvatar?.frame.size)!),
                                                                 onComplete: { [weak self] (chache, image, error) in
                                                                    
                                                                    if self != nil && image != nil {
                                                                        
                                                                        UIView.transitionWithView(self!,
                                                                            duration: chache == .Cache ? 0 : 0.3,
                                                                            options: .TransitionCrossDissolve,
                                                                            animations: {
                                                                                self?.personAvatar?.image = image
                                                                            },
                                                                            completion: nil)
                                                                        
                                                                    }
                })
            }
        }

    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Actions

}
