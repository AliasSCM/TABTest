//
//  CharacterDetailViewController.swift
//  TABTest
//
//  Created by master on 4/22/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController , UITableViewDataSource , UITableViewDelegate ,  CharacterTableViewCellProtocol
{

    @IBOutlet var tableView: UITableView!
    var character : Character!
    var viewModel : CharacterModels.CharacterDetail.CharacterDetailVM!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if(character != nil)
        {
            viewModel = CharacterViewModelFactory.makeCharacterDetailViewModel(character: character)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 2
        
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
        if(indexPath.row == 0)
        {
             let cell = tableView.dequeueReusableCell(withIdentifier: CharacterModels.ListCharacters.CharacterCellVM.CellID , for : indexPath) as! CharacterTableViewCell
            cell.delegate = self
            CharacterPresenter.presentChacracterCell(cell: cell , viewModel: viewModel.headingModel)
            
            return cell
        }
        else if(indexPath.row == 1)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterModels.CharacterDetail.CharacterDescriptionCellVM.CellID , for : indexPath) as! CharacterDescriptionTableViewCell
           CharacterPresenter.presentChacracterDescriptionCell(cell: cell, viewModel: viewModel.descriptionVM)
            
            return cell
        }
       return UITableViewCell()
    }
 
    
}
