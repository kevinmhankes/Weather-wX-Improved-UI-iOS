// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

class UIwXViewController: UIViewController {

    //
    // parent class for most viewcontrollers, sets up
    // basic UI elements - toolbar, stackview, scrollview
    // refresh when comining into focus
    // swipe from left edge
    //

    var scrollView = UIScrollView()
    var stackView = ObjectStackView(.fill, .horizontal)
    let toolbar = ObjectToolbar()
    var doneButton = ToolbarIcon()
    var objScrollStackView: ScrollStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked))
    }

    //
    // each class that has this as a parent should override getContent()
    // in some cases willEnterForeground needs to be overriden
    //
    @objc func willEnterForeground() {
        getContent()
    }

    func getContent() {}

    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            doneClicked()
        }
    }

    @objc func doneClicked() {
        dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    func refreshViews() {
        removeAllViews()
        scrollView = UIScrollView()
        stackView = ObjectStackView(.fill, .horizontal)
        view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        objScrollStackView = ScrollStackView(self)
    }

    func removeAllViews() {
        view.subviews.forEach { $0.removeFromSuperview() }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                    // print("Dark mode")
                } else {
                    AppColors.update()
                    // print("Light mode")
                }
                view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
                toolbar.setColorToTheme()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    /*override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: UIKeyCommand.inputEscape,
             modifierFlags: [],
             action: #selector(doneClicked))
        ]
    }*/
}
