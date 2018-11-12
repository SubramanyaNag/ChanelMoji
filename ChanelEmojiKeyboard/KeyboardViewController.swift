//
//  KeyboardViewController.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import UIKit
import MobileCoreServices
class ImageCollectionViewCell:UICollectionViewCell {
    @IBOutlet var imgView:UIImageView!
}

class KeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    var imgArray = NSMutableArray()
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
       // Add custom view sizing constraints here
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Loading Xib
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as! UIView;
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        for i in 1...4 {
            self.imgArray.add("a\(i).png")
        }
        self.collectionView.reloadData()
        self.view.bringSubview(toFront: self.collectionView)
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    //==================================================
    // Function Name: returnPressed
    // Function Parameter: button: UIButton
    // Function ReturnType: nil
    // Function Purpose: To return textfield
    //==================================================
    @IBAction func returnPressed(_ sender: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
    }
    
    //==================================================
    // Function Name: nextKeyboardPressed
    // Function Parameter: button: UIButton
    // Function ReturnType: nil
    // Function Purpose: To change keyboard type
    //==================================================
    @IBAction func nextKeyboardPressed(button: UIButton) {
        advanceToNextInputMode()
    }
    
    
    //Collectionview delegate methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let iCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
        iCell.imgView.image = UIImage(named: self.imgArray.object(at: indexPath.row) as! String)
        return iCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pb = UIPasteboard.general
        let data = UIImagePNGRepresentation( UIImage(named: self.imgArray.object(at: indexPath.row) as! String)!)
        pb.setData(data!, forPasteboardType: kUTTypePNG as String)
        
        let iCell = self.collectionView.cellForItem(at: indexPath as IndexPath) as! ImageCollectionViewCell
        UIView.animate(withDuration: 0.2, animations: {
            iCell.transform = iCell.transform.scaledBy(x: 2.0, y: 2.0)
            }, completion: {(_) -> Void in
                iCell.transform =
                   CGAffineTransform.identity
        })
        (textDocumentProxy as UIKeyInput).insertText("   ")
    }
}
