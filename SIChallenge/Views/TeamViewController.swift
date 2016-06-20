//
//  TeamViewController.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 15/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import UIKit

////////////////////////////////////////////////////////////////////////////////
// MARK: Types


/**
 *  TeamViewController Inherit UIViewController
 */
class TeamViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Constants
    static let collectionCellAspectRatio:CGFloat = 1.3

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties
    
    private let refreshCtrl = UIRefreshControl()
    private var team: Team?
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties
    
    lazy var api:ISApi = { ISApi.defaultInstance }()
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    
    @IBOutlet weak var teamNameLabel: UILabel?
    @IBOutlet weak var collectionView: UICollectionView?
    
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Override Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Inavalidate collection layout, to recalculate collection cell size
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    
    private func setup(){
        
        refreshCtrl.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        self.collectionView?.addSubview(refreshCtrl)
        
        // Need this setup to allow pull to refresh in empty collection view
        self.collectionView?.alwaysBounceVertical = true;
    }

    @objc private func loadData(){
        self.api.getTeam { (team, error) in
            
            self.refreshCtrl.endRefreshing()
            
            self.team = team
            
            // Clean cache to force reload all images
            ImageManager.defaultManager.cleanCache()

            self.presentData()
            
            if error != nil {
                self.presentError(error!)
            }
        }
    }

    private func presentData(){
        if self.team != nil {
            self.teamNameLabel?.text = self.team?.name
            self.collectionView?.reloadData()
        }else{
            self.presentEmptyTeam()
        }
    }
    
    private func presentEmptyTeam(){
        self.teamNameLabel?.text = "Team not found"
        self.collectionView?.reloadData()
    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Alert Methods
    
    private func presentError(error:NSError){
        let alertController = UIAlertController(title: "SI Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .Alert)
        
        let actionOk = UIAlertAction(title: "OK",
                                     style: .Default,
                                     handler: nil)
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func presentInfo(info:String){
        let alertController = UIAlertController(title: "SI Info",
                                                message: info,
                                                preferredStyle: .Alert)
        
        let actionOk = UIAlertAction(title: "OK",
                                     style: .Default,
                                     handler: nil)
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /**
     This is just a simple and ugly alert :),  added to display some feedback to the user.
     */
    private func pendingAlert(title:String) -> UIAlertController {
        let pending = UIAlertController(title: title+"\n\n", message: nil, preferredStyle: .Alert)
        
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.activityIndicatorViewStyle = .Gray
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false
        indicator.startAnimating()
        
        return pending
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: UICollectionViewDataSource
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.team != nil ? self.team!.players.count : 0
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlayerCellId", forIndexPath: indexPath) as! PlayerCell
        
        cell.player = self.team!.players[indexPath.row]
        cell.teamColor = self.team!.settings?.highlightColor
        
        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: UICollectionViewDelegate
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if let player:Player = self.team?.players[indexPath.row]{
            
            let pendingAlert = self.pendingAlert("Tapping Player")
            self.presentViewController(pendingAlert, animated: true, completion: nil)

            self.api.tapped(self.team?.id,
                            playerid: player.id,
                            playerFirstName: player.person?.firstName,
                            playerLastName: player.person?.lastName,
                            onCompletion: { (error) in
                                
                                pendingAlert.dismissViewControllerAnimated(true, completion: { 
                                    if error != nil {
                                        self.presentError(error!)
                                    }else{
                                        self.presentInfo("User tapped successfully")
                                    }
                                })
                                
            })
        }
    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        // Get the cell's width necessary to display 3 cells per row and leave a 5px margin between the cells
        let w = ((self.collectionView?.frame.size.width)! - 10) / 3
        
        // Return final cell size, having in mind the aspect ratio of the cell
        return CGSize(width: w , height: w * TeamViewController.collectionCellAspectRatio);
    }
}
