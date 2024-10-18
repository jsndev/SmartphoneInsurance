//
//  SmartphoneShortcutActions.swift
//  Smartphone
//
//  Created by F0129579 on 04/03/22.
//  Copyright © 2022 Porto Seguro. All rights reserved.
//

import Foundation

public struct SmartphoneShortcutActions {
    let moreOptionsShortcutAction: SmartphoneMoreOptionsShortcutCompletion?
    
    public init( moreOptionsShortcutAction: SmartphoneMoreOptionsShortcutCompletion?) {
        self.moreOptionsShortcutAction = moreOptionsShortcutAction
    }
}
