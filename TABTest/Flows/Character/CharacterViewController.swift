//
//  CharacterViewController.swift
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

/// All methods relating to updating the view controllers view.
protocol CharacterDisplayLogic: class{
    /// Display logic to display a list of characters. Consumes  CharacterModels.ListCharacters.CharacterListVM object for displaying on table view.
    /// - parameter listViewModel: ViewModel object that contains all information to render a list of Character entities on screen.
    func displayCharacterList(listViewModel : CharacterModels.ListCharacters.CharacterListVM)
    /// Display logic to display an error when character list fails.
    /// - parameter errorMessage : Error Message as a string
    func displayCharacterListError(errorMessage : String)
}
/// View Controller class that shows a list of character entites in a table view.
/// - important: Follow these steps to use class
/// + View Interactor Presenter Router Relationship needs to be setup before using this class.
/// + Character Display logic has to be implemented.
/// + Implement table view data source and delegate methods.
/// + The table view uses CharacterTableView cell which is dynamically sized based on image asynchronously loaded so it has to implement CharacterTableViewCellProtocol to get notified when image download completes. Use this handler to update table view accordingly.
class CharacterViewController: BaseViewController, CharacterDisplayLogic , UITableViewDelegate , UITableViewDataSource , CharacterTableViewCellProtocol{
    // MARK: VIPER iVars.
    /// interactor variable the view controller uses to call business logic or pass touch events.
    var interactor: CharacterBusinessLogic?
    /// router variable that is used to route between view controllers in the character scene
    var router: (NSObjectProtocol & CharacterRoutingLogic & CharacterDataPassing)?
    /// private variable viewmodel that is used to display character information
    private var viewModel : CharacterModels.ListCharacters.CharacterListVM!
    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    // MARK: Init
    /// Custom init method overriding init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    /// - important : Call 'setup()' method from inside this function to setup VIPER relationship
     override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    /// Custom init method overriding init?(coder aDecoder: NSCoder)
    /// - important : Call 'setup()' method from inside this function to setup VIPER relationship
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    // MARK: VIPER Setup
    /// Setup method to setup the VIPER relationship between view controller, interacter, router & presenter.
    /// - important : This has to be done the right way so that all VIPER dependencies are correctly satisfied
    private func setup()
    {
        let viewController = self
        let interactor = CharacterInteractor()
        let presenter = CharacterPresenter()
        let router = CharacterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: Routing
    
    // MARK: View lifecycle
    /// Overriding viewDidLoad.
    /// - important : Do these here.
    /// + Assign datasource and delegate to table view to self.
    /// + Call interactor business logic to get all characters from endpoint to display on screen.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate      =   self
        tableView.dataSource    =   self
        self.showActivityIndicator("Calling Marvel!")
        interactor?.getCharactersFromEndPoint(request: CharacterModels.ListCharacters.Request())
    }
    /// Overriding viewWillAppear.
    /// - important : Do these here.
    /// + Set navigation bar title.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Characters"
        
    }
    // MARK: Implementing CharacterViewControllerDisplayLogic
    
    /// Displays character list in the table view
    /// - parameter listViewModel : The view model that contains all the data to be rendered onto table view.
    func displayCharacterList(listViewModel: CharacterModels.ListCharacters.CharacterListVM)
    {
        self.removeActivityIndicator()
        viewModel = listViewModel
        self.tableView.reloadData()
    }
    /// Displays error when character list fails
    /// - parameter errorMessage : The error message as string.
    func displayCharacterListError(errorMessage: String)
    {
        self.showAlert(title: "Thor's hammer is too heavy to lift!", descrip: "We could not load this for you at this time. Please try again")
    }
  
    // MARK: Implementing CharacterTableViewCellProtocol
    
    /// Implemented CharacterTableViewCellProtocol to get notified when image finishes downloading.
    /// - important: This is being done since images are being downloaded asynchronously and the table view cell is being sized according to the size of the downlaoded image. Do any update to concerning table view cell here.
    /// - parameter cell : TableViewCell that called this method
    func shouldLayoutTable(cell : UITableViewCell)
    {
      
        if let indexPath = self.tableView.indexPath(for: cell)
        {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath] , with: .automatic)
            self.tableView.endUpdates()
        }
      
      
    }
   
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(viewModel != nil)
        {
            return viewModel.cellViewModels.count
        }
        return 0
        
    }
    /// Returns estimated height.
    /// - important : This has to be done since we are using Self Sizing Cells.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    /// Returns height.
    /// - important : This has to be done since we are using Self Sizing Cells. Has to return Automatic dimension
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterModels.ListCharacters.CharacterCellVM.CellID , for : indexPath) as! CharacterTableViewCell
        cell.delegate = self
        CharacterPresenter.presentChacracterCell(cell: cell , viewModel: viewModel.cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.selectCharacter(indexPath: indexPath)
        router?.routeToChallengeDetail(segue: nil)
    }
}
