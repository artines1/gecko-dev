/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The origin of this IDL file is a combination of the FIDO U2F Raw Message Formats:
 * https://www.fidoalliance.org/specs/fido-u2f-v1.1-id-20160915/fido-u2f-raw-message-formats-v1.1-id-20160915.html
 * and the U2F JavaScript API v1.1:
 * https://www.fidoalliance.org/specs/fido-u2f-v1.1-id-20160915/fido-u2f-javascript-api-v1.1-id-20160915.html
 */

interface mixin GlobalU2F {
  [SecureContext, Throws, Pref="security.webauth.u2f", Replaceable]
  readonly attribute U2F u2f;
};

typedef unsigned short ErrorCode;
typedef sequence<Transport> Transports;

enum Transport {
    "bt",
    "ble",
    "nfc",
    "usb"
};

dictionary U2FClientData {
    DOMString             typ; // Spelling is from the specification
    DOMString             challenge;
    DOMString             origin;
    // cid_pubkey for Token Binding is not implemented
};

dictionary RegisterRequest {
    DOMString version;
    DOMString challenge;
};

dictionary RegisterResponse {
    DOMString version;
    DOMString registrationData;
    DOMString clientData;

    // From Error
    ErrorCode? errorCode;
    DOMString? errorMessage;
};

dictionary RegisteredKey {
    DOMString   version;
    DOMString   keyHandle;
    Transports? transports;
    DOMString?  appId;
};

dictionary SignResponse {
    DOMString keyHandle;
    DOMString signatureData;
    DOMString clientData;

    // From Error
    ErrorCode? errorCode;
    DOMString? errorMessage;
};

callback U2FRegisterCallback = void(RegisterResponse response);
callback U2FSignCallback = void(SignResponse response);

[SecureContext, Pref="security.webauth.u2f",
 Exposed=Window]
interface U2F {
  // These enumerations are defined in the FIDO U2F Javascript API under the
  // interface "ErrorCode" as constant integers, and also in the U2F.cpp file.
  // Any changes to these must occur in both locations.
  const unsigned short OK = 0;
  const unsigned short OTHER_ERROR = 1;
  const unsigned short BAD_REQUEST = 2;
  const unsigned short CONFIGURATION_UNSUPPORTED = 3;
  const unsigned short DEVICE_INELIGIBLE = 4;
  const unsigned short TIMEOUT = 5;

  // Returns a Function.  It's readonly + [LenientSetter] to keep the Google
  // U2F polyfill from stomping on the value.
  [LenientSetter, Pure, Cached, Throws]
  readonly attribute object register;

  // A way to generate the actual implementation of register()
  [Unexposed, Throws, BinaryName="Register"]
  void register_impl(DOMString appId,
                     sequence<RegisterRequest> registerRequests,
                     sequence<RegisteredKey> registeredKeys,
                     U2FRegisterCallback callback,
                     optional long? opt_timeoutSeconds);

  // Returns a Function.  It's readonly + [LenientSetter] to keep the Google
  // U2F polyfill from stomping on the value.
  [LenientSetter, Pure, Cached, Throws]
  readonly attribute object sign;

  // A way to generate the actual implementation of sign()
  [Unexposed, Throws, BinaryName="Sign"]
  void sign_impl (DOMString appId,
                  DOMString challenge,
                  sequence<RegisteredKey> registeredKeys,
                  U2FSignCallback callback,
                  optional long? opt_timeoutSeconds);
};
