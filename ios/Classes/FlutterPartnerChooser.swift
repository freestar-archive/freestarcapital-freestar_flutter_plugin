//
//  FlutterPartnerChooser.swift
//  freestar_flutter_plugin
//
//  Created by Lev Trubov on 7/13/21.
//

import UIKit

@objc public enum FreestarFlutterAdUnit : Int {
    case Interstitial
    case Rewarded
    case Banner
    case MREC
    case SmallNative
    case MediumNative
}

struct PartnerChoice {
    var name: String
    var selected = false
}

@objc public protocol FlutterPartnerChooserDelegate: AnyObject {
    func partnersSelected(_ partners: [String])
    func chooserDismissed()
}

public class FlutterPartnerChooser: UITableViewController {
    
    var partnerList = [PartnerChoice]()
    weak var delegate: FlutterPartnerChooserDelegate?
    
    
    @objc public convenience init(adType: FreestarFlutterAdUnit, delegate: FlutterPartnerChooserDelegate? = nil) {
        self.init()
        self.partnerList = partnerListForAdType(adType)
        self.delegate = delegate
    }
    
    func partnerListForAdType(_ type: FreestarFlutterAdUnit) -> [PartnerChoice] {
        switch type {
        case .Interstitial: return [PartnerChoice(name: "All", selected: true)] + [
                "AdColony",
                "GoogleAdmob",
                "Unity",
                "AppLovin",
                "Vungle",
                "Criteo",
                "Google",
                "TAM",
                "Nimbus"].map { PartnerChoice(name: $0) }
        case .Rewarded: return [PartnerChoice(name: "All", selected: true)] + [
                "AdColony",
                "GoogleAdmob",
                "Unity",
                "AppLovin",
                "Vungle",
                "Criteo",
                "Mopub",
                "Google",
                "Tapjoy",
                "Nimbus" ].map { PartnerChoice(name: $0) }
        case .MREC: return [PartnerChoice(name: "All", selected: true)] + [
                "AppLovin",
                "GoogleAdmob",
                "Mopub",
                "Nimbus",
                "Criteo",
                "Google" ].map { PartnerChoice(name: $0) }
        case .Banner: return [PartnerChoice(name: "All", selected: true)] + [
                "GoogleAdmob",
                "Criteo",
                "Mopub",
                "Nimbus",
                "AppLovin",
                "Unity" ].map { PartnerChoice(name: $0) }
        case .SmallNative: return [PartnerChoice(name: "All", selected: true)] + [
                "Google",
                "Googleadmob",
                "Mopub" ].map { PartnerChoice(name: $0) }
        case .MediumNative: return [PartnerChoice(name: "All", selected: true)] + [
                "Google",
                "Googleadmob",
                "Mopub" ].map { PartnerChoice(name: $0) }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Ad Partner";
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "partnerCell")
        
//        self.navigationItem.rightBarButtonItem =
//            UIBarButtonItem(barButtonSystemItem: .done,
//                            target: self,
//                            action: #selector(FlutterPartnerChooser.closeAndExit))
    }
    
//    @objc func closeAndExit() {
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partnerList.count
    }

    //*
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partnerCell", for: indexPath)

        // Configure the cell...
        let pc = partnerList[indexPath.row]
        cell.textLabel?.text = pc.name
        cell.accessoryType = pc.selected ? .checkmark : .none

        return cell
    }
    //*/

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if partnerList[indexPath.row].name == "All"  {
            for i in 1..<partnerList.count {
                partnerList[i].selected = false
            }
            partnerList[indexPath.row].selected = true
        } else {
            partnerList[0].selected = false
            partnerList[indexPath.row].selected.toggle()
        }
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            cell?.accessoryType = partnerList[i].selected ? .checkmark : .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.partnersSelected(self.extractChosenPartners())
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate?.chooserDismissed()
    }
    
    func extractChosenPartners() -> [String] {
        if partnerList[0].selected {
            return ["all"]
        }
        
        return partnerList.filter { $0.selected }.map { $0.name.lowercased() }
    }
}

