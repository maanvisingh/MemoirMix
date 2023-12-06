//
//  NoteTableView.swift
//  MemoirMix
//
//  Created by Tharun on 23/11/23.
//

import Foundation
import UIKit
import CoreData
import NaturalLanguage

var noteList=[Note]()
class NoteTableView: UITableViewController{
    var firstLoad=true
    var receivedDate: Date?
    var receivedUser: String?
    func analyzeSentiment(for text: String) -> String {
        let sentimentPredictor = NLTagger(tagSchemes: [.sentimentScore])
        sentimentPredictor.string = text

        let (sentiment, _) = sentimentPredictor.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return mapSentimentToEmoji(sentiment?.rawValue ?? "")
    }
    func mapSentimentToEmoji(_ sentimentScore: String) -> String {
        guard let score = Double(sentimentScore) else { return "🤔" }
        switch score {
        case let x where x > 0.0:
            return "😊"
        case let x where x < 0.0:
            return "😞"
        default:
            return "😐"
        }
    }
    func nonDeletedNotes() -> [Note]
        {
            var noDeleteNoteList = [Note]()
            for note in noteList
            {
                if(note.deletedDate == nil)
                {
                    noDeleteNoteList.append(note)
                }
            }
            return noDeleteNoteList
        }
    override func viewDidLoad() {
        if(firstLoad)
        {
            firstLoad=false
            noteList=[]
            let appDelegate=UIApplication.shared.delegate as! AppDelegate
            let context :NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    if note.dateAdded==receivedDate && note.username==receivedUser
                    {
                        noteList.append(note)
                    }
                }
            }
            catch{
                print("Fetch Failed")
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell=tableView.dequeueReusableCell(withIdentifier: "noteCellID" ,for: indexPath) as! NoteCell
        let thisNode: Note!
        thisNode=nonDeletedNotes()[indexPath.row]
        noteCell.titleLabel.text=thisNode.title
        noteCell.descriptionLabel.text=thisNode.desc
        noteCell.sentimentLabel.text=analyzeSentiment(for: thisNode.desc)
        return noteCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedNotes().count
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NoteDetailVC
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if segue.identifier=="newNote"
        {
            if let destinationVC = segue.destination as? NoteDetailVC{
                destinationVC.receivedDate=receivedDate
            }
            if let destinationVC = segue.destination as? NoteDetailVC{
                destinationVC.receivedUser=receivedUser
            }
        }
    }
    
}
