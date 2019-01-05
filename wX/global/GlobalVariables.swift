/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import AVFoundation
import UIKit

// FIXME move away from global variables
var globalSynth = AVSpeechSynthesizer()
let flexBarButton = UIBarButtonItem(
    barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
    target: nil,
    action: nil
)
let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
let preferences = Preferences()
let editor = Editor()
