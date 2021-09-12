package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

import com.freestar.android.ads.AdRequest;
import com.freestar.android.ads.LVDOConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Only for testing purposes!
 */
public class MediationPartners {

    private static final int numInterstitial = 13;
    private static final int numRewarded = 12;
    private static final int numInview = 10;
    private static final int numPreroll = 4;

    public static final int ADTYPE_INTERSTITIAL = 0;
    public static final int ADTYPE_REWARDED = 1;
    public static final int ADTYPE_BANNER = 2;
    public static final int ADTYPE_PREROLL = 3;

    /**
     * INTERSTITIAL
     */
    private static final String[] interstitial_partners = new String[numInterstitial];

    static {
        interstitial_partners[0] = LVDOConstants.PARTNER.ADCOLONY.name();
        interstitial_partners[1] = LVDOConstants.PARTNER.APPLOVIN.name();
        interstitial_partners[2] = LVDOConstants.PARTNER.CRITEO.name();
        interstitial_partners[3] = LVDOConstants.PARTNER.FACEBOOK.name();
        interstitial_partners[4] = LVDOConstants.PARTNER.GOOGLEADMOB.name();
        interstitial_partners[5] = LVDOConstants.PARTNER.GOOGLE.name();
        interstitial_partners[6] = LVDOConstants.PARTNER.MOPUB.name();
        interstitial_partners[7] = LVDOConstants.PARTNER.NIMBUS.name();
        interstitial_partners[8] = LVDOConstants.PARTNER.TAM.name();
        interstitial_partners[9] = LVDOConstants.PARTNER.TAPJOY.name();
        interstitial_partners[10] = LVDOConstants.PARTNER.UNITY.name();
        interstitial_partners[11] = LVDOConstants.PARTNER.VUNGLE.name();
        interstitial_partners[12] = LVDOConstants.PARTNER.PANGLE.name();
    }

    private static final boolean[] interstitial_parters_selected = new boolean[numInterstitial];

    static {
        for (int i = 0; i < numInterstitial; i++) {
            interstitial_parters_selected[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setInterstitialPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(numInterstitial);
        for (int i = 0; i < numInterstitial; i++) {
            if (interstitial_parters_selected[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(interstitial_partners[i]));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }


    /**
     * REWARDED
     */
    private static String[] rewarded_partners = new String[numRewarded];

    static {
        rewarded_partners[0] = LVDOConstants.PARTNER.ADCOLONY.name();
        rewarded_partners[1] = LVDOConstants.PARTNER.APPLOVIN.name();
        rewarded_partners[2] = LVDOConstants.PARTNER.CRITEO.name();
        rewarded_partners[3] = LVDOConstants.PARTNER.FACEBOOK.name();
        rewarded_partners[4] = LVDOConstants.PARTNER.GOOGLEADMOB.name();
        rewarded_partners[5] = LVDOConstants.PARTNER.GOOGLE.name();
        rewarded_partners[6] = LVDOConstants.PARTNER.MOPUB.name();
        rewarded_partners[7] = LVDOConstants.PARTNER.NIMBUS.name();
        rewarded_partners[8] = LVDOConstants.PARTNER.TAPJOY.name();
        rewarded_partners[9] = LVDOConstants.PARTNER.UNITY.name();
        rewarded_partners[10] = LVDOConstants.PARTNER.VUNGLE.name();
        rewarded_partners[11] = LVDOConstants.PARTNER.PANGLE.name();
    }

    private static boolean[] rewarded_parters_selected = new boolean[numRewarded];

    static {
        for (int i = 0; i < numRewarded; i++) {
            rewarded_parters_selected[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setRewardedPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(numRewarded);
        for (int i = 0; i < numRewarded; i++) {
            if (rewarded_parters_selected[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(rewarded_partners[i]));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }

    /**
     * NATIVE INVIEW
     */
    private static final String[] inview_partners = new String[numInview];

    static {
        inview_partners[0] = LVDOConstants.PARTNER.APPLOVIN.name();
        inview_partners[1] = LVDOConstants.PARTNER.CRITEO.name();
        inview_partners[2] = LVDOConstants.PARTNER.FACEBOOK.name();
        inview_partners[3] = LVDOConstants.PARTNER.GOOGLEADMOB.name();
        inview_partners[4] = LVDOConstants.PARTNER.GOOGLE.name();
        inview_partners[5] = LVDOConstants.PARTNER.MOPUB.name();
        inview_partners[6] = LVDOConstants.PARTNER.NIMBUS.name();
        inview_partners[7] = LVDOConstants.PARTNER.TAM.name();
        inview_partners[8] = LVDOConstants.PARTNER.UNITY.name();
        inview_partners[9] = LVDOConstants.PARTNER.PANGLE.name();
    }

    private static final boolean[] inview_parters_selected = new boolean[numInview];

    static {
        for (int i = 0; i < numInview; i++) {
            inview_parters_selected[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setInviewPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(numInview);
        for (int i = 0; i < numInview; i++) {
            if (inview_parters_selected[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(inview_partners[i]));
            }
        }
        adRequest.setPartnerNames(list);
        return list;
    }

    /**
     * PRE-ROLL
     */
    private static final String[] preroll_partners = new String[numPreroll];

    static {
        preroll_partners[0] = LVDOConstants.PARTNER.AMAZON.name();
        preroll_partners[1] = LVDOConstants.PARTNER.CRITEO.name();
        preroll_partners[2] = LVDOConstants.PARTNER.GOOGLE.name();
        preroll_partners[3] = LVDOConstants.PARTNER.NIMBUS.name();
    }

    private static final boolean[] preroll_parters_selected = new boolean[numPreroll];

    static {
        for (int i = 0; i < numPreroll; i++) {
            preroll_parters_selected[i] = true;
        }
    }

    private static List<LVDOConstants.PARTNER> setPrerollPartners(AdRequest adRequest) {
        List<LVDOConstants.PARTNER> list = new ArrayList<>(numPreroll);
        for (int i = 0; i < numPreroll; i++) {
            if (preroll_parters_selected[i]) {
                list.add(LVDOConstants.PARTNER.valueOf(preroll_partners[i]));
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
            partners = interstitial_partners;
            selected = interstitial_parters_selected;
            title = "Interstitial";
        } else if (adUnitType == ADTYPE_REWARDED) {
            partners = rewarded_partners;
            selected = rewarded_parters_selected;
            title = "Rewarded";
        } else if (adUnitType == ADTYPE_BANNER) {
            partners = inview_partners;
            selected = inview_parters_selected;
            title = "Display";
        } else {
            partners = preroll_partners;
            selected = preroll_parters_selected;
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
            partners = interstitial_partners;
            selected = interstitial_parters_selected;
            total = numInterstitial;
            chosen = new String[numInterstitial];
        } else if (adUnitType == ADTYPE_REWARDED) {
            partners = rewarded_partners;
            selected = rewarded_parters_selected;
            total = numRewarded;
            chosen = new String[numRewarded];
        } else if (adUnitType == ADTYPE_BANNER) {
            partners = inview_partners;
            selected = inview_parters_selected;
            total = numInview;
            chosen = new String[numInview];
        } else {
            partners = preroll_partners;
            selected = preroll_parters_selected;
            total = numPreroll;
            chosen = new String[numPreroll];
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
