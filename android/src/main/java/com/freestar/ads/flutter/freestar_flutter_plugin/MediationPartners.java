package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

import com.freestar.android.ads.AdRequest;
import com.freestar.android.ads.LVDOConstants;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Only for testing purposes!
 */
public class MediationPartners {

    public static final int ADTYPE_INTERSTITIAL = 0;
    public static final int ADTYPE_REWARDED = 1;
    public static final int ADTYPE_BANNER = 2;
    public static final int ADTYPE_PREROLL = 3;

    /**
     * INTERSTITIAL
     */
    private static final List<String> sInterstitialPartners = new ArrayList<>(30);
    private static final boolean[] sSelectedInterstitialPartners;

    static {
        sInterstitialPartners.add(LVDOConstants.PARTNER.ADCOLONY.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.APPLOVIN.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.APPLOVINMAX.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.CRITEO.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.GOOGLEADMOB.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.GOOGLE.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.HYPRMX.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.NIMBUS.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.PANGLE.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.TAM.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.TAPJOY.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.UNITY.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.VUNGLE.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.YAHOO.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.PREBID.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.OGURY.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.FYBER.name());
        sInterstitialPartners.add(LVDOConstants.PARTNER.SMAATO.name());
        Collections.sort(sInterstitialPartners);
        sSelectedInterstitialPartners = new boolean[sInterstitialPartners.size()];
        for (int i = 0; i < sInterstitialPartners.size(); i++) {
            sSelectedInterstitialPartners[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setInterstitialPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(sInterstitialPartners.size());
        for (int i = 0; i < sInterstitialPartners.size(); i++) {
            if (sSelectedInterstitialPartners[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(sInterstitialPartners.get(i)));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }


    /**
     * REWARDED
     */
    private static final List<String> sRewardedPartners = new ArrayList<>(30);
    private static final boolean[] sSelectedRewardedPartners;

    static {
        sRewardedPartners.add(LVDOConstants.PARTNER.ADCOLONY.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.APPLOVIN.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.APPLOVINMAX.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.CRITEO.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.GOOGLEADMOB.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.GOOGLE.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.NIMBUS.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.TAPJOY.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.UNITY.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.VUNGLE.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.PANGLE.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.HYPRMX.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.PREBID.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.OGURY.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.FYBER.name());
        sRewardedPartners.add(LVDOConstants.PARTNER.SMAATO.name());
        Collections.sort(sRewardedPartners);
        sSelectedRewardedPartners = new boolean[sRewardedPartners.size()];
        for (int i = 0; i < sRewardedPartners.size(); i++) {
            sSelectedRewardedPartners[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setRewardedPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(sRewardedPartners.size());
        for (int i = 0; i < sRewardedPartners.size(); i++) {
            if (sSelectedRewardedPartners[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(sRewardedPartners.get(i)));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }

    /**
     * NATIVE INVIEW
     */
    private static final List<String> sBannerPartners = new ArrayList<>(30);
    private static final boolean[] sSelectedBannerPartners;

    static {
        sBannerPartners.add(LVDOConstants.PARTNER.TAM.name());
        sBannerPartners.add(LVDOConstants.PARTNER.ADCOLONY.name());
        sBannerPartners.add(LVDOConstants.PARTNER.APPLOVIN.name());
        sBannerPartners.add(LVDOConstants.PARTNER.APPLOVINMAX.name());
        sBannerPartners.add(LVDOConstants.PARTNER.CRITEO.name());
        sBannerPartners.add(LVDOConstants.PARTNER.GOOGLEADMOB.name());
        sBannerPartners.add(LVDOConstants.PARTNER.GOOGLE.name());
        sBannerPartners.add(LVDOConstants.PARTNER.NIMBUS.name());
        sBannerPartners.add(LVDOConstants.PARTNER.UNITY.name());
        sBannerPartners.add(LVDOConstants.PARTNER.PANGLE.name());
        sBannerPartners.add(LVDOConstants.PARTNER.VUNGLE.name());
        sBannerPartners.add(LVDOConstants.PARTNER.HYPRMX.name());
        sBannerPartners.add(LVDOConstants.PARTNER.YAHOO.name());
        sBannerPartners.add(LVDOConstants.PARTNER.PREBID.name());
        sBannerPartners.add(LVDOConstants.PARTNER.OGURY.name());
        sBannerPartners.add(LVDOConstants.PARTNER.FYBER.name());
        sBannerPartners.add(LVDOConstants.PARTNER.SMAATO.name());
        Collections.sort(sBannerPartners);
        sSelectedBannerPartners = new boolean[sBannerPartners.size()];
        for (int i = 0; i < sBannerPartners.size(); i++) {
            sSelectedBannerPartners[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setInviewPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(sBannerPartners.size());
        for (int i = 0; i < sBannerPartners.size(); i++) {
            if (sSelectedBannerPartners[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(sBannerPartners.get(i)));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }

    /**
     * PRE-ROLL
     */
    private static final List<String> sPrerollPartners = new ArrayList<>(30);
    private static final boolean[] sSelectedPrerollPartners;

    static {
        sPrerollPartners.add(LVDOConstants.PARTNER.GOOGLE.name());
        sPrerollPartners.add(LVDOConstants.PARTNER.NIMBUS.name());
        Collections.sort(sPrerollPartners);
        sSelectedPrerollPartners = new boolean[sPrerollPartners.size()];
        for (int i = 0; i < sPrerollPartners.size(); i++) {
            sSelectedPrerollPartners[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setPrerollPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(sPrerollPartners.size());
        for (int i = 0; i < sPrerollPartners.size(); i++) {
            if (sSelectedPrerollPartners[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(sPrerollPartners.get(i)));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }

    /**
     * @param adUnitType
     * @param context
     * @param listener
     */
    public static void choosePartners(final Context context, final AdRequest adRequest, final int adUnitType, final DialogInterface.OnClickListener listener) {
        String[] partners;
        boolean[] selected;
        String title;
        if (adUnitType == ADTYPE_INTERSTITIAL) {
            partners = new String[sInterstitialPartners.size()];
            sInterstitialPartners.toArray(partners);
            selected = sSelectedInterstitialPartners;
            title = "Interstitial";
        } else if (adUnitType == ADTYPE_REWARDED) {
            partners = new String[sRewardedPartners.size()];
            sRewardedPartners.toArray(partners);
            selected = sSelectedRewardedPartners;
            title = "Rewarded";
        } else if (adUnitType == ADTYPE_BANNER) {
            partners = new String[sBannerPartners.size()];
            sBannerPartners.toArray(partners);
            selected = sSelectedBannerPartners;
            title = "Display";
        } else {
            partners = new String[sPrerollPartners.size()];
            sPrerollPartners.toArray(partners);
            selected = sSelectedPrerollPartners;
            title = "Pre-Roll";
        }
        //w/out the listener, even though it does nothing, things don't work so well
        //so we need to pass a listener
        new AlertDialog.Builder(context).setMultiChoiceItems(partners, selected, new DialogInterface.OnMultiChoiceClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which, boolean isChecked) {

                    }
                })
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        switch (adUnitType) {
                            case ADTYPE_INTERSTITIAL:
                                setInterstitialPartners(adRequest);
                                break;
                            case ADTYPE_BANNER:
                                setInviewPartners(adRequest);
                                break;
                            case ADTYPE_PREROLL:
                                setPrerollPartners(adRequest);
                                break;
                            case ADTYPE_REWARDED:
                                setRewardedPartners(adRequest);
                                break;
                            default:
                                break;
                        }
                        listener.onClick(dialog,which);
                    }
                })
                .setNegativeButton("CANCEL", dummyOnClick)
                .setTitle(title)
                .show();

    }

    private static final DialogInterface.OnClickListener dummyOnClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {

        }
    };

    /**
     * @param adUnitType 0:interstitial, 1:rewarded, 2:inview, 3:preroll
     */
    static String[] getChosenPartners(int adUnitType) {
        String[] partners;
        boolean[] selected;
        String[] chosen;
        int total;
        if (adUnitType == ADTYPE_INTERSTITIAL) {
            partners = new String[sInterstitialPartners.size()];
            sInterstitialPartners.toArray(partners);
            selected = sSelectedInterstitialPartners;
            total = sInterstitialPartners.size();
            chosen = new String[sInterstitialPartners.size()];
        } else if (adUnitType == ADTYPE_REWARDED) {
            partners = new String[sRewardedPartners.size()];
            sRewardedPartners.toArray(partners);
            selected = sSelectedRewardedPartners;
            total = sRewardedPartners.size();
            chosen = new String[sRewardedPartners.size()];
        } else if (adUnitType == ADTYPE_BANNER) {
            partners = new String[sBannerPartners.size()];
            sBannerPartners.toArray(partners);
            selected = sSelectedBannerPartners;
            total = sBannerPartners.size();
            chosen = new String[sBannerPartners.size()];
        } else {
            partners = new String[sPrerollPartners.size()];
            sPrerollPartners.toArray(partners);
            selected = sSelectedPrerollPartners;
            total = sPrerollPartners.size();
            chosen = new String[sPrerollPartners.size()];
        }
        int j=0;
        for (int i=0;i<total;i++) {
            if (selected[i]) {
                chosen[j++] = partners[i];
            }
        }
        return chosen;
    }

}
