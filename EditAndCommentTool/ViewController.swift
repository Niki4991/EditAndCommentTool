//
//  ViewController.swift
//  EditAndCommentTool
//
//  Created by User_218 on 18/03/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func commentBtnTapped(_ sender: UIButton)
    {
        let annotation_VC = storyboard?.instantiateViewController(withIdentifier: "AnnotationDisplayViewController") as? AnnotationDisplayViewController
        annotation_VC?.modalPresentationStyle = .overCurrentContext
        self.present(annotation_VC!, animated: true, completion: nil)
    }
    
}

