//
//  MapBannerDelegate.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 04/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//


import GoogleMobileAds
extension MapViewController: GADBannerViewDelegate {
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.bannerView.isHidden = true
        self.setUpExpandConstrain()
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerView.isHidden = false
        self.setUpExpandConstrain()
    }

}
