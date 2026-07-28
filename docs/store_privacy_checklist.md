# Store privacy and classification

## Shared store metadata

- English name: `Hint Master: Charades Game`
- Apple subtitle: `Guess Words With Friends`
- Google short description: `Play charades, guess words and find the Chameleon with friends and family.`
- Support URL: `https://hartvigsolutions.com/#hint-master`
- Privacy policy URL: `https://hartvigsolutions.com/?privacypolicy=true#hint-master`

## Categories

- Apple: Games → Trivia (primary) and Word (secondary)
- Google Play: Game → Word

## App Store privacy

The app does not request App Tracking Transparency permission. Ad requests are
non-personalized, and AdMob publisher first-party identifiers are disabled.
User ID is not declared, and none of the declared data types are marked as
tracking.

Keep the declarations required by the integrated SDKs:

- Purchase History: App Functionality and Analytics; not linked; not tracking.
- Coarse Location: Third-Party Advertising, Analytics, and App Functionality;
  linked; not tracking.
- Product Interaction / Advertising Data: Third-Party Advertising and
  Analytics. Product Interaction also has App Functionality and is linked;
  neither is marked as tracking.
- Crash Data: Analytics; not linked; not tracking.
- Performance Data: Third-Party Advertising and Analytics; not linked; not
  tracking.

Review the generated Xcode privacy report for the release archive before
submitting, because SDK disclosures can change between versions.

## Google Play Data safety

AdMob automatically collects and shares approximate location derived from IP,
app interactions, diagnostics, and device or other identifiers. RevenueCat
collects purchase history. The declaration must therefore not say “No data
collected”.

- Approximate location: collected and shared for advertising, analytics, and
  fraud prevention.
- Purchase history: collected for app functionality and analytics.
- App interactions: collected and shared for advertising, analytics, and fraud
  prevention.
- Diagnostics: collected and shared for advertising, analytics, and fraud
  prevention.
- Device or other IDs: collected and shared for advertising, analytics, and
  fraud prevention.
- Data is encrypted in transit.
- Deletion requests can be handled through
  `hintmaster@hartvigsolutions.com`.
- The currently published Android artifact still contains the Advertising ID
  permission, so its Advertising ID declaration is Yes for advertising,
  analytics, and fraud prevention. The next artifact removes the permission;
  change this declaration to No together with that release.

## Link availability

The certificate for `hartvigsolutions.com` was repaired on 2026-07-28. Google
Play's automated URL check now passes, and the pending metadata changes can be
sent for review.

## Age rating

The word database contains infrequent references to alcoholic drinks. Keep the
corresponding infrequent alcohol reference in the questionnaires. The app has
advertising and in-app purchases, but no gambling, user-generated content,
chat, unrestricted web access, loot boxes, or graphic violence.
