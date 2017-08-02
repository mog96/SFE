//
//  ContactUsViewController.swift
//  SFE
//
//  Created by Mateo Garcia on 8/2/17.
//  Copyright © 2017 Story for Everyone. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {

    @IBOutlet weak var subjectTextView: CustomTextView!
    @IBOutlet weak var messageTextView: CustomTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.subjectTextView.placeholder = "Subject"
        self.subjectTextView.placeholderLabel.textColor = UIColor.lightText
        self.subjectTextView.nextTextView = self.messageTextView
        
        self.messageTextView.placeholder = "Message"
        self.messageTextView.placeholderLabel.textColor = UIColor.lightText
        
        if let subject = UserDefaults().object(forKey: "ContactUsSubject") as? String {
            self.subjectTextView.setText(text: subject)
        }
        if let message = UserDefaults().object(forKey: "ContactUsMessage") as? String {
            self.messageTextView.setText(text: message)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults().set(self.subjectTextView.text, forKey: "ContactUsSubject")
        UserDefaults().set(self.messageTextView.text, forKey: "ContactUsMessage")
    }
}


// MARK: - Actions

extension ContactUsViewController {
    @IBAction func onSendButtonTapped(_ sender: Any) {
        self.sendMessage()
    }
}


// MARK: - Mail Compose

// MARK: - Feedback Mail Compose

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func sendMessage() {
        if MFMailComposeViewController.canSendMail() {
            var subject = self.subjectTextView.text
            let recipient = "mateog@stanford.edu"
            var body = self.messageTextView.text

            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setSubject(subject)
            mailComposeVC.setToRecipients([recipient])
            mailComposeVC.setMessageBody(body, isHTML: false)
            self.present(mailComposeVC, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Mail Not Enabled", message: "Could not send message. Set up a mail account for your device and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // TODO: Handle each mail case? i.e. sent, not sent, etc.
        
        if result == MFMailComposeResult.sent {
            let alert = UIAlertController(title: "Thank You!", message: "We'll get back to you as soon as possible.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            UserDefaults().removeObject(forKey: "ContactUsSubject")
            UserDefaults().removeObject(forKey: "ContactUsMessage")
        }
    }
}
