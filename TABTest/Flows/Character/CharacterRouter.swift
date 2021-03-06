//
//  CharacterRouter.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright (c) 2018 neemo. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol to do routing logic of the character to route from chacrter list to chacreter detail
@objc protocol CharacterRoutingLogic
{
    /// Function to route to challenge detail screen
    /// - parameter segue : Optional segue parameter
    func routeToChallengeDetail(segue: UIStoryboardSegue?)
}
/// Character Data passing that is used to pass data between character scenes while routing.
protocol CharacterDataPassing
{
    ///datastore property that has the character data store to store data about the chacrter
    var dataStore: CharacterDataStore? { get }
}

/// Router class to route between view controllers related to the charcacter class.
class CharacterRouter: NSObject, CharacterRoutingLogic, CharacterDataPassing
{
    /// view controller class that does character listing
    weak var viewController: CharacterViewController?
    /// data store that stores data for character data
    var dataStore: CharacterDataStore?
    
    // MARK: Routing
    
    /// Fucntion to route to challemge detail view controller
    /// - parameter segue : Optional segue parameter
    func routeToChallengeDetail(segue: UIStoryboardSegue?)
    {
        if let segue = segue
        {
            var destinationVC = segue.destination as! CharacterDetailViewController
            passDataToDetail(source: dataStore!, destination: &destinationVC)
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var destinationVC = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
            
            passDataToDetail(source: dataStore!, destination: &destinationVC)
            navigateToSomewhere(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    /// Method that performs navigation logic to navigate to character detail view controoler
    /// - parameter source : Character view controller which is the starting vew controller for this navigation
    /// - parameter destination : Destination which is the character detail view controller
    func navigateToSomewhere(source: CharacterViewController, destination: CharacterDetailViewController)
    {
        source.show(destination, sender: nil)
    }
    
    //MARK: Passing data
    
    /// Function to pass data to character detail view controller
    /// - parameter source : CharacterData source which is the source data
    /// - parameter destination : Destination which is the character detail view controller
    func passDataToDetail(source: CharacterDataStore, destination: inout CharacterDetailViewController)
    {
        destination.character = source.selectedCharacter
    }
}
