//
//  MainBaseController.swift
//  MyYouTube
//
//  Created by 松本和也 on 9/22/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import UIKit

class MovieBaseViewController: UIViewController {
    var pageMenu : CAPSPageMenu?
    var orderDic : Dictionary = [YoutubeAPI.ORDER_RELEVANCE : Const.listTitleRelevance,
                                 YoutubeAPI.ORDER_DATE : Const.listTitleDate,
                                 YoutubeAPI.ORDER_RATING : Const.listTitleRate,
                                 YoutubeAPI.ORDER_FAVORITE : Const.listTitleFavorite
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        var controllerArray : [UIViewController] = []
        print(Const.menuOrder)
        for menu in Const.menuOrder {
            let controller : MovieListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("movie_list") as! MovieListViewController
            controller.apiOrder = menu
            controller.title = orderDic[menu]!
            controllerArray.append(controller)
        }

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(Const.applicationColor),
            .MenuItemSeparatorColor (Const.applicationColor),
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .MenuItemSeparatorRoundEdges(true),
            .MenuItemWidthBasedOnTitleTextWidth (true),
            .UnselectedMenuItemLabelColor (UIColor.whiteColor()),
            .MenuHeight(Const.menuHeight),
            .MenuItemHeight(Const.menuHeight - statusBarHeight),
            .AddBottomMenuHairline(false)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
