//
//  NoteDetailVC.swift
//  MemoirMix
//
//  Created by Tharun on 23/11/23.
//

import UIKit
import CoreData
class NoteDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedNote: Note? = nil
    var receivedDate: Date?
    var receivedUser: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedNote != nil)
                {
                    titleTextField.text = selectedNote?.title
                    descriptionTextField.text = selectedNote?.desc
                }
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        let context :NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil)
                {
                    let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
                    let newNote = Note(entity: entity!, insertInto: context)
                    newNote.id = noteList.count as NSNumber
                    newNote.title = titleTextField.text
                    newNote.desc = descriptionTextField.text
                    newNote.dateAdded = receivedDate
                    newNote.username = receivedUser
                    do
                    {
                        try context.save()
                        noteList.append(newNote)
                        navigationController?.popViewController(animated: true)
                    }
                    catch
                    {
                        print("context save error")
                    }
                }
        else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                        do {
                            let results:NSArray = try context.fetch(request) as NSArray
                            for result in results
                            {
                                let note = result as! Note
                                if(note == selectedNote)
                                {
                                    note.title = titleTextField.text
                                    note.desc = descriptionTextField.text
                                    try context.save()
                                    navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                        catch
                        {
                            print("Fetch Failed")
                        }

        }
    }
    
    @IBAction func deleteNode(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                do {
                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results
                    {
                        let note = result as! Note
                        if(note == selectedNote)
                        {
                            note.deletedDate = Date()
                            try context.save()
                            navigationController?.popViewController(animated: true)
                        }
                    }
                }
                catch
                {
                    print("Fetch Failed")
                }
    }
    
    
    
    
    @IBOutlet weak var cameraPreview: UIImageView!
    
    
    @IBAction func tappedCam(_ sender: Any) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              cameraPreview?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
          picker.dismiss(animated: true, completion: nil)
  }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
