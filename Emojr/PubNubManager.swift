//
//  PubNubManager.swift
//  Emojr
//
//  Created by James on 4/5/17.
//  Copyright © 2017 Joseph Pecoraro. All rights reserved.
//

import Foundation
import PubNub

class PushManager: NSObject, PNObjectEventListener {
    
    static let instance = PushManager()
    
    private var client: PubNub?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        self.client = PubNub.client()
        self.client?.addListener(self)
        self.client?.subscribeToChannels(["announcements"], withPresence: false)
    }

    // MARK: - Push Notification Registration
    
    func registerForPushNotification() {
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.client?.addPushNotificationsOnChannels(["announcements"], withDevicePushToken: deviceToken,
                                                    andCompletion: { (status) -> Void in
                                                        
                                                        if !status.isError {
                                                            
                                                            print("Handle successful push notification enabling on passed channels.")
                                                        }
                                                        else {
                                                            
                                                            print("Handle modification error.")
                                                            
                                                            // Check 'category' property
                                                            // to find out possible reason because of which request did fail.
                                                            // Review 'errorData' property (which has PNErrorData data type) of status
                                                            // object to get additional information about issue.
                                                            //
                                                            // Request can be resent using: status.retry()
                                                        }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push notifications")
    }

    // MARK: - Messaging
    
    func publishAnnouncement(message: [String: String]) {
        self.client = PubNub.client()
        self.client?.publish(message, toChannel: "announcements", withCompletion: { (status) -> Void in
            
            if !status.isError {
                
                print("Message successfully published to specified channel.")
            }
            else{
                
                print("Handle message publish error.")
                
                // Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about the issue.
                //
                // Request can be resent using: status.retry()
            }
        })
    }
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        
        
        // Handle new message stored in message.data.message
        if message.data.subscription != nil {
            
            //print("Message has been received on channel group stored in \(message.data.subscription)")
        }
        else {
            //print("Message has been received on channel stored in \(message.data.channel)")
        }
        
        print("Received message: \(message.data.message) on channel " +
            "\((message.data.subscription ?? message.data.channel)!) at " +
            "\(message.data.timetoken)")
    }
}
