/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsRFPService.h"

#include "mozilla/ClearOnShutdown.h"
#include "mozilla/Preferences.h"
#include "mozilla/StaticPtr.h"

#include "nsCOMPtr.h"
#include "nsServiceManagerUtils.h"
#include "nsString.h"

#include "nsIPrefBranch.h"
#include "nsIPrefService.h"
#include "nsJSUtils.h"

#include "prenv.h"

using namespace mozilla;

#define RESIST_FINGERPRINTING_PREF "privacy.resistFingerprinting"

NS_IMPL_ISUPPORTS(nsRFPService, nsIObserver)

static StaticRefPtr<nsRFPService> gRFPService;
bool nsRFPService::sPrivacyResistFingerprinting = false;

/* static */
nsRFPService*
nsRFPService::GetOrCreate()
{
  if (!gRFPService) {
      gRFPService = new nsRFPService();
      gRFPService->Init();
      ClearOnShutdown(&gRFPService);
  }

  return gRFPService;
}

nsresult
nsRFPService::Init()
{
  nsCOMPtr<nsIPrefBranch> prefs = do_GetService(NS_PREFSERVICE_CONTRACTID);

  prefs->AddObserver(RESIST_FINGERPRINTING_PREF, this, false);

  UpdatePrefs();
  return NS_OK;
}

void
nsRFPService::UpdatePrefs()
{
  sPrivacyResistFingerprinting = Preferences::GetBool(RESIST_FINGERPRINTING_PREF);

  if (sPrivacyResistFingerprinting) {
    PR_SetEnv("TZ=UTC");
  } else {
    PR_SetEnv("TZ=:/etc/localtime");
  }

  nsJSUtils::ResetTimeZone();
}

NS_IMETHODIMP
nsRFPService::Observe(nsISupports* aObject, const char* aTopic,
                      const char16_t* aMessage)
{
  if (!strcmp(NS_PREFBRANCH_PREFCHANGE_TOPIC_ID, aTopic)) {
    NS_ConvertUTF16toUTF8 pref(aMessage);

    if (pref.EqualsLiteral(RESIST_FINGERPRINTING_PREF)) {
      UpdatePrefs();
    }
  }

  return NS_OK;
}
