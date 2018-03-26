//
//  ViewController.swift
//  To Do List
//
//  Created by Enoka Jayamanne on 2/22/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var defaultData = UserDefaults.standard
    var toDoArray = [String]()
    var toDoNotesArray = [String]()
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        toDoArray = defaultData.stringArray(forKey: "toDoArray") ?? [String]()
        toDoNotesArray = defaultData.stringArray(forKey: "toDoNotesArray") ?? [String]()
    }
    func saveDefaults(){
        defaultData.set(toDoArray, forKey: "toDoArray")
        defaultData.set(toDoNotesArray, forKey: "toDoNotesArray")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem"{
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destination.toDoItem = toDoArray[index]
            destination.toDoNote = toDoNotesArray[index]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue){
        let sourceViewController = segue.source as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            toDoArray[indexPath.row] = sourceViewController.toDoItem!
            toDoNotesArray[indexPath.row] = sourceViewController.toDoNote!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else {
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            toDoArray.append(sourceViewController.toDoItem!)
            toDoNotesArray.append(sourceViewController.toDoNote!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveDefaults()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else{
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        cell.detailTextLabel?.text = toDoNotesArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoArray.remove(at: indexPath.row)
            toDoNotesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaults()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoArray[sourceIndexPath.row]
        let itemNoteToMove = toDoNotesArray[sourceIndexPath.row]
        toDoArray.remove(at: sourceIndexPath.row)
        toDoNotesArray.remove(at: sourceIndexPath.row)
        toDoArray.insert(itemToMove, at: destinationIndexPath.row)
        toDoNotesArray.insert(itemNoteToMove, at: destinationIndexPath.row)
        saveDefaults()
    }
}


