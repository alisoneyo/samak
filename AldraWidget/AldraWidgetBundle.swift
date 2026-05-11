//
//  AldraWidgetBundle.swift
//  AldraWidget
//
//  Created by Alison Eyo on 09/05/2026.
//

import WidgetKit
import SwiftUI

@main
struct AldraWidgetBundle: WidgetBundle {
    var body: some Widget {
        AldraWidget()
        AldraWidgetControl()
        AldraWidgetLiveActivity()
    }
}
