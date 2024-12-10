//
//  ViewController.swift
//  Project10
//
//  Created by Maksim Li on 07/12/2024.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let ac = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self?.presentImagePicker(with: .camera)
            } else {
                self?.presentImagePicker(with: .photoLibrary)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(with: .photoLibrary)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: imagePath)
            } catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Choose an action", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let renameAC = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            renameAC.addTextField()
            
            renameAC.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak renameAC] _ in
                guard let newName = renameAC?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            renameAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self?.present(renameAC, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            let confirmDelete = UIAlertController(title: "Are you sure?", message: "This will permanently delete the image.", preferredStyle: .alert)
            confirmDelete.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.deletePerson(at: indexPath)
            })
            confirmDelete.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(confirmDelete, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func deletePerson(at indexPath: IndexPath) {
        let person = people[indexPath.item]
        let imagePath = getDocumentDirectory().appendingPathComponent(person.image)
        
        do {
            try FileManager.default.removeItem(at: imagePath)
        } catch {
            print("Error deleting image: \(error.localizedDescription)")
        }
        
        people.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}
