// -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

var EXPORTED_SYMBOLS = ["RFPHelper"];

ChromeUtils.import("resource://gre/modules/Services.jsm");
ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

const kPrefResistFingerprinting = "privacy.resistFingerprinting";
const kPrefSpoofEnglish = "privacy.spoof_english";
const kTopicHttpOnModifyRequest = "http-on-modify-request";
const kTopicRFPContentSizeUpdates = "resistfingerprinting:content-size-updates";
const kTopicDOMWindowOpened = "domwindowopened";

const kTooltipTextContentMargins = "Margins for protection from browser fingerprinting";

class _RFPHelper {
  constructor() {
    this._initialized = false;
  }

  init() {
    if (this._initialized) {
      return;
    }
    this._initialized = true;

    Services.prefs.addObserver(kPrefResistFingerprinting, this);
    this._handleResistFingerprintingChanged();
  }

  uninit() {
    if (!this._initialized) {
      return;
    }
    this._initialized = false;

    Services.prefs.removeObserver(kPrefResistFingerprinting, this);
    this._removeObservers();
  }

  observe(subject, topic, data) {
    switch (topic) {
      case "nsPref:changed":
        this._handlePrefChanged(data);
        break;
      case kTopicHttpOnModifyRequest:
        this._handleHttpOnModifyRequest(subject, data);
        break;
      case kTopicRFPContentSizeUpdates:
        this._handleContentSizeUpdates(subject);
        break;
      case kTopicDOMWindowOpened:
        // We would attach the new created window by adding tabsProgressListener
        // and event listener on that. We would listen for adding new tabs and the
        // change of the content principal and apply margins accordingly.
        this._handleDOMWindowOpened(subject);
        break;
      default:
        break;
    }
  }

  handleEvent(aMessage) {
    switch (aMessage.type) {
      case "TabOpen":
      {
        let tab = aMessage.target;
        let win = tab.ownerGlobal;
        let tabBrowser = win.gBrowser;

        this._maybeRoundContentView(tab.linkedBrowser, tabBrowser);
        break;
      }
      case "sizemodechange":
      {
        let win = aMessage.target;
        this._handleSizeModeChanged(win);
        break;
      }
      default:
        break;
    }
  }

  /**
   * We use the TabsProgressListener to catch the change of the content principal.
   * We would clear the margin around the browser if the content principal is the
   * system principal.
   */
  onLocationChange(aBrowser, aWebProgress, aRequest, aLocation, aFlags) {
    if (aBrowser.contentPrincipal.isSystemPrincipal) {
      let tabBrowser = aBrowser.ownerGlobal.gBrowser;
      this._clearContentViewRounding(aBrowser, tabBrowser);
    } else {
      let tabBrowser = aBrowser.ownerGlobal.gBrowser;
      this._maybeRoundContentView(aBrowser, tabBrowser);
    }
  }

  _addObservers() {
    // Add observers for the language prompt.
    Services.prefs.addObserver(kPrefSpoofEnglish, this);
    if (this._shouldPromptForLanguagePref()) {
      Services.obs.addObserver(this, kTopicHttpOnModifyRequest);
    }

    // Add observers for the window letterboxing including observing the size change
    // of the browser element and the creation of a new window.
    Services.obs.addObserver(this, kTopicRFPContentSizeUpdates);
    Services.ww.registerNotification(this);
  }

  _removeObservers() {
    try {
      Services.pref.removeObserver(kPrefSpoofEnglish, this);
    } catch (e) {
      // do nothing
    }
    try {
      Services.obs.removeObserver(this, kTopicHttpOnModifyRequest);
      Services.obs.removeObserver(this, kTopicRFPContentSizeUpdates);
      Services.ww.unregisterNotification(this);
    } catch (e) {
      // do nothing
    }
  }

  _shouldPromptForLanguagePref() {
    return (Services.locale.getAppLocaleAsLangTag().substr(0, 2) !== "en")
      && (Services.prefs.getIntPref(kPrefSpoofEnglish) === 0);
  }

  _handlePrefChanged(data) {
    switch (data) {
      case kPrefResistFingerprinting:
        this._handleResistFingerprintingChanged();
        break;
      case kPrefSpoofEnglish:
        this._handleSpoofEnglishChanged();
        break;
      default:
        break;
    }
  }

  _handleResistFingerprintingChanged() {
    if (Services.prefs.getBoolPref(kPrefResistFingerprinting)) {
      this._addObservers();
      this._attachWindows();
    } else {
      this._detachWindows();
      this._removeObservers();
    }
  }

  _handleSpoofEnglishChanged() {
    switch (Services.prefs.getIntPref(kPrefSpoofEnglish)) {
      case 0: // will prompt
        // This should only happen when turning privacy.resistFingerprinting off.
        // Works like disabling accept-language spoofing.
      case 1: // don't spoof
        if (Services.prefs.prefHasUserValue("javascript.use_us_english_locale")) {
          Services.prefs.clearUserPref("javascript.use_us_english_locale");
        }
        // We don't reset intl.accept_languages. Instead, setting
        // privacy.spoof_english to 1 allows user to change preferred language
        // settings through Preferences UI.
        break;
      case 2: // spoof
        Services.prefs.setCharPref("intl.accept_languages", "en-US, en");
        Services.prefs.setBoolPref("javascript.use_us_english_locale", true);
        break;
      default:
        break;
    }
  }

  _handleHttpOnModifyRequest(subject, data) {
    // If we are loading an HTTP page from content, show the
    // "request English language web pages?" prompt.
    let httpChannel;
    try {
      httpChannel = subject.QueryInterface(Ci.nsIHttpChannel);
    } catch (e) {
      return;
    }

    if (!httpChannel) {
      return;
    }

    let notificationCallbacks = httpChannel.notificationCallbacks;
    if (!notificationCallbacks) {
      return;
    }

    let loadContext = notificationCallbacks.getInterface(Ci.nsILoadContext);
    if (!loadContext || !loadContext.isContent) {
      return;
    }

    if (!subject.URI.schemeIs("http") && !subject.URI.schemeIs("https")) {
      return;
    }
    // The above QI did not throw, the scheme is http[s], and we know the
    // load context is content, so we must have a true HTTP request from content.
    // Stop the observer and display the prompt if another window has
    // not already done so.
    Services.obs.removeObserver(this, kTopicHttpOnModifyRequest);

    if (!this._shouldPromptForLanguagePref()) {
      return;
    }

    this._promptForLanguagePreference();

    // The Accept-Language header for this request was set when the
    // channel was created. Reset it to match the value that will be
    // used for future requests.
    let val = this._getCurrentAcceptLanguageValue(subject.URI);
    if (val) {
      httpChannel.setRequestHeader("Accept-Language", val, false);
    }
  }

  _promptForLanguagePreference() {
    // Display two buttons, both with string titles.
    let flags = Services.prompt.STD_YES_NO_BUTTONS;
    let brandBundle = Services.strings.createBundle(
      "chrome://branding/locale/brand.properties");
    let brandShortName = brandBundle.GetStringFromName("brandShortName");
    let navigatorBundle = Services.strings.createBundle(
      "chrome://browser/locale/browser.properties");
    let message = navigatorBundle.formatStringFromName(
      "privacy.spoof_english", [brandShortName], 1);
    let response = Services.prompt.confirmEx(
      null, "", message, flags, null, null, null, null, {value: false});

    // Update preferences to reflect their response and to prevent the prompt
    // from being displayed again.
    Services.prefs.setIntPref(kPrefSpoofEnglish, (response == 0) ? 2 : 1);
  }

  _getCurrentAcceptLanguageValue(uri) {
    let channel = Services.io.newChannelFromURI2(
        uri,
        null, // aLoadingNode
        Services.scriptSecurityManager.getSystemPrincipal(),
        null, // aTriggeringPrincipal
        Ci.nsILoadInfo.SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL,
        Ci.nsIContentPolicy.TYPE_OTHER);
    let httpChannel;
    try {
      httpChannel = channel.QueryInterface(Ci.nsIHttpChannel);
    } catch (e) {
      return null;
    }
    return httpChannel.getRequestHeader("Accept-Language");
  }

  /**
   * The function would round the given browser by adding margins if its size is
   * not quantized when fingerprinting resistance is enable.
   */
  _maybeRoundContentView(aBrowser, aTabBrowser) {
    if (!aBrowser || !aTabBrowser) {
      return;
    }

    let contentWidth = aBrowser.clientWidth;
    let contentHeight = aBrowser.clientHeight;

    // If the size of the content is already quantized, we do nothing.
    if (0 === (contentWidth % 128) && 0 === (contentHeight % 100)) {
      return;
    }

    // Rounding the browser element by adding margins.
    let browserContainer = aTabBrowser.getBrowserContainer(aBrowser);
    let containerWidth = browserContainer.clientWidth;
    let containerHeight = browserContainer.clientHeight;
    let marginWidth = (containerWidth % 128) / 2;
    let marginHeight = (containerHeight % 100) / 2;

    aBrowser.style.margin = `${marginHeight}px ${marginWidth}px`;

    // Adding a tooltip on the margin.
    browserContainer.setAttribute("tooltiptext", kTooltipTextContentMargins);
  }

  _clearContentViewRounding(aBrowser, aTabBrowser) {
    if (!aBrowser || !aTabBrowser) {
      return;
    }

    let browserContainer = aTabBrowser.getBrowserContainer(aBrowser);
    aBrowser.style.margin = "";
    browserContainer.clearAttribute("tooltiptext");
  }

  _attachWindow(aWindow, aRoundContent = true) {
    let tabBrowser = aWindow.gBrowser;
    tabBrowser.addTabsProgressListener(this);
    aWindow.addEventListener("TabOpen", this);
    aWindow.addEventListener("sizemodechange", this);

    // Rounding the existing browsers.
    for (const tab of tabBrowser.tabs) {
      let browser = tab.linkedBrowser;

      if (!browser.contentPrincipal.isSystemPrincipal) {
        if (aRoundContent) {
          this._maybeRoundContentView(browser, tabBrowser);
        }

        this._handleSizeModeChanged(aWindow);
      }
    }
  }

  _attachWindows() {
    let windowList = Services.wm.getEnumerator("navigator:browser");

    while (windowList.hasMoreElements()) {
      let win = windowList.getNext();

      if (win.closed || !win.gBrowser) {
        continue;
      }

      this._attachWindow(win);
    }
  }

  _detachWindow(aWindow) {
    let tabBrowser = aWindow.gBrowser;
    tabBrowser.removeTabsProgressListener(this);
    aWindow.removeEventListener("TabOpen", this);
    aWindow.removeEventListener("sizemodechange", this);

    // Clear all margins and tooltip for all browsers.
    for (const tab of tabBrowser.tabs) {
      let browser = tab.linkedBrowser;
      this._clearContentViewRounding(browser, tabBrowser);
    }

    // Clear the background color of browser containers.
    this._setBrowserContainersBackgroundColor(tabBrowser, "");
  }

  _detachWindows() {
    let windowList = Services.wm.getEnumerator("navigator:browser");

    while (windowList.hasMoreElements()) {
      let win = windowList.getNext();

      if (win.closed || !win.gBrowser) {
        continue;
      }

      this._detachWindow(win);
    }
  }

  _handleContentSizeUpdates(aSubject) {
    let frameLoader = aSubject;
    let browserElement = frameLoader.ownerElement;
    let tabBrowser = browserElement.ownerGlobal
                                   .gBrowser;

    if (!browserElement.contentPrincipal.isSystemPrincipal) {
      this._maybeRoundContentView(browserElement, tabBrowser);
    }
  }

  _handleDOMWindowOpened(aSubject) {
    let win = aSubject.QueryInterface(Ci.nsIDOMWindow);
    let self = this;

    win.addEventListener("load", () => {
      // We attach the new window when it has been loaded. But, we won't
      // round the content here since the window already been rounded when
      // fingerprinting resistance is enabled.
      self._attachWindow(win, false);
    }, {once: true});
  }

  _setBrowserContainersBackgroundColor(aTabBrowser, aColor) {
    if (!aTabBrowser) {
      return;
    }

    for (const tab of aTabBrowser.tabs) {
      let container = aTabBrowser.getBrowserContainer(tab.linkedBrowser);

      container.style.backgroundColor = aColor;
    }
  }

  _handleSizeModeChanged(aWindow) {
    let tabBrowser = aWindow.gBrowser;

    if (aWindow.STATE_FULLSCREEN === aWindow.windowState) {
      this._setBrowserContainersBackgroundColor(tabBrowser, "black");
    } else {
      this._setBrowserContainersBackgroundColor(tabBrowser, "");
    }
  }
}

let RFPHelper = new _RFPHelper();
