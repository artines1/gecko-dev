/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/KeyboardEvent.h"
#include "mozilla/TextEvents.h"
#include "nsContentUtils.h"
#include "prtime.h"

namespace mozilla {
namespace dom {

KeyboardEvent::KeyboardEvent(EventTarget* aOwner,
                             nsPresContext* aPresContext,
                             WidgetKeyboardEvent* aEvent)
  : UIEvent(aOwner, aPresContext,
            aEvent ? aEvent :
                     new WidgetKeyboardEvent(false, eVoidEvent, nullptr))
  , mInitializedByCtor(false)
  , mInitializedWhichValue(0)
{
  if (aEvent) {
    mEventIsInternal = false;
  }
  else {
    mEventIsInternal = true;
    mEvent->mTime = PR_Now();
    mEvent->AsKeyboardEvent()->mKeyNameIndex = KEY_NAME_INDEX_USE_STRING;
  }
}

NS_IMPL_ADDREF_INHERITED(KeyboardEvent, UIEvent)
NS_IMPL_RELEASE_INHERITED(KeyboardEvent, UIEvent)

NS_INTERFACE_MAP_BEGIN(KeyboardEvent)
  NS_INTERFACE_MAP_ENTRY(nsIDOMKeyEvent)
NS_INTERFACE_MAP_END_INHERITING(UIEvent)

bool
KeyboardEvent::AltKey()
{
  bool altState = mEvent->AsKeyboardEvent()->IsAlt();

  if (ShouldResistFingerprinting()) {
    bool unused;
    nsAutoString keyName;
    GetKey(keyName);

    // We will give a false for Alt key when there is a spoofing shift state.
    // This is because the Alt key will be always false for regular US English
    // QWERTY keyboard when shift key is present. But for other keyboard layout,
    // it might not be. For example, the '@' key for German keyboard for MAC is
    // Alt+L. For US English, it is Shift+2, so we need to give Alt a spoofed
    // value as well.
    bool exists = nsRFPService::GetSpoofedShiftKeyState(keyName, &unused);

    altState = exists ? false : altState;
  }

  return altState;
}

NS_IMETHODIMP
KeyboardEvent::GetAltKey(bool* aIsDown)
{
  NS_ENSURE_ARG_POINTER(aIsDown);
  *aIsDown = AltKey();
  return NS_OK;
}

bool
KeyboardEvent::CtrlKey()
{
  return mEvent->AsKeyboardEvent()->IsControl();
}

NS_IMETHODIMP
KeyboardEvent::GetCtrlKey(bool* aIsDown)
{
  NS_ENSURE_ARG_POINTER(aIsDown);
  *aIsDown = CtrlKey();
  return NS_OK;
}

bool
KeyboardEvent::ShiftKey()
{
  bool shiftState = mEvent->AsKeyboardEvent()->IsShift();

  if (ShouldResistFingerprinting()) {
    bool fakeShiftState = false;
    nsAutoString keyName;

    GetKey(keyName);
    bool exists = nsRFPService::GetSpoofedShiftKeyState(keyName, &fakeShiftState);

    shiftState = exists ? fakeShiftState : shiftState;
  }

  return shiftState;
}

NS_IMETHODIMP
KeyboardEvent::GetShiftKey(bool* aIsDown)
{
  NS_ENSURE_ARG_POINTER(aIsDown);
  *aIsDown = ShiftKey();
  return NS_OK;
}

bool
KeyboardEvent::MetaKey()
{
  return mEvent->AsKeyboardEvent()->IsMeta();
}

NS_IMETHODIMP
KeyboardEvent::GetMetaKey(bool* aIsDown)
{
  NS_ENSURE_ARG_POINTER(aIsDown);
  *aIsDown = MetaKey();
  return NS_OK;
}

bool
KeyboardEvent::Repeat()
{
  return mEvent->AsKeyboardEvent()->mIsRepeat;
}

NS_IMETHODIMP
KeyboardEvent::GetRepeat(bool* aIsRepeat)
{
  NS_ENSURE_ARG_POINTER(aIsRepeat);
  *aIsRepeat = Repeat();
  return NS_OK;
}

bool
KeyboardEvent::IsComposing()
{
  return mEvent->AsKeyboardEvent()->mIsComposing;
}

NS_IMETHODIMP
KeyboardEvent::GetModifierState(const nsAString& aKey,
                                bool* aState)
{
  NS_ENSURE_ARG_POINTER(aState);

  *aState = GetModifierState(aKey);
  return NS_OK;
}

NS_IMETHODIMP
KeyboardEvent::GetKey(nsAString& aKeyName)
{
  mEvent->AsKeyboardEvent()->GetDOMKeyName(aKeyName);
  return NS_OK;
}

void
KeyboardEvent::GetCode(nsAString& aCodeName)
{
  if (ShouldResistFingerprinting()) {
    // Use a consensus code name corresponding to the
    // key name.
    nsAutoString keyName;
    nsAutoString codeName;
    GetKey(keyName);

    bool exists = nsRFPService::GetSpoofedCode(keyName, codeName);

    if (exists) {
      aCodeName.Assign(codeName);
    }
  } else {
    mEvent->AsKeyboardEvent()->GetDOMCodeName(aCodeName);
  }
}

void KeyboardEvent::GetInitDict(KeyboardEventInit& aParam)
{
  GetKey(aParam.mKey);
  GetCode(aParam.mCode);
  aParam.mLocation = Location();
  aParam.mRepeat = Repeat();
  aParam.mIsComposing = IsComposing();

  // legacy attributes
  aParam.mKeyCode = KeyCode();
  aParam.mCharCode = CharCode();
  aParam.mWhich = Which();

  // modifiers from EventModifierInit
  aParam.mCtrlKey = CtrlKey();
  aParam.mShiftKey = ShiftKey();
  aParam.mAltKey = AltKey();
  aParam.mMetaKey = MetaKey();

  WidgetKeyboardEvent* internalEvent = mEvent->AsKeyboardEvent();
  aParam.mModifierAltGraph = internalEvent->IsAltGraph();
  aParam.mModifierCapsLock = internalEvent->IsCapsLocked();
  aParam.mModifierFn = internalEvent->IsFn();
  aParam.mModifierFnLock = internalEvent->IsFnLocked();
  aParam.mModifierNumLock = internalEvent->IsNumLocked();
  aParam.mModifierOS = internalEvent->IsOS();
  aParam.mModifierScrollLock = internalEvent->IsScrollLocked();
  aParam.mModifierSymbol = internalEvent->IsSymbol();
  aParam.mModifierSymbolLock = internalEvent->IsSymbolLocked();

  // EventInit
  aParam.mBubbles =  internalEvent->mFlags.mBubbles;
  aParam.mCancelable = internalEvent->mFlags.mCancelable;
}

NS_IMETHODIMP
KeyboardEvent::GetCharCode(uint32_t* aCharCode)
{
  NS_ENSURE_ARG_POINTER(aCharCode);
  *aCharCode = CharCode();
  return NS_OK;
}

uint32_t
KeyboardEvent::CharCode()
{
  // If this event is initialized with ctor, we shouldn't check event type.
  if (mInitializedByCtor) {
    return mEvent->AsKeyboardEvent()->mCharCode;
  }

  switch (mEvent->mMessage) {
  case eKeyDown:
  case eKeyDownOnPlugin:
  case eKeyUp:
  case eKeyUpOnPlugin:
    return 0;
  case eKeyPress:
  case eAccessKeyNotFound:
    return mEvent->AsKeyboardEvent()->mCharCode;
  default:
    break;
  }
  return 0;
}

NS_IMETHODIMP
KeyboardEvent::GetKeyCode(uint32_t* aKeyCode)
{
  NS_ENSURE_ARG_POINTER(aKeyCode);
  *aKeyCode = KeyCode();
  return NS_OK;
}

uint32_t
KeyboardEvent::KeyCode()
{
  // If this event is initialized with ctor, we shouldn't check event type.
  if (mInitializedByCtor) {
    return mEvent->AsKeyboardEvent()->mKeyCode;
  }

  if (mEvent->HasKeyEventMessage()) {
    uint32_t keyCode = mEvent->AsKeyboardEvent()->mKeyCode;
    if (ShouldResistFingerprinting()) {
      if (CharCode() != 0) {
        return 0;
      }

      nsAutoString keyName;
      GetKey(keyName);

      // Find a consensus key code for the given key name.
      bool exists = nsRFPService::GetSpoofedKeyCode(keyName, &keyCode);
      if (!exists) {
        keyCode = 0;
      }
    }
    return keyCode;
  }
  return 0;
}

uint32_t
KeyboardEvent::Which()
{
  // If this event is initialized with ctor, which can have independent value.
  if (mInitializedByCtor) {
    return mInitializedWhichValue;
  }

  switch (mEvent->mMessage) {
    case eKeyDown:
    case eKeyDownOnPlugin:
    case eKeyUp:
    case eKeyUpOnPlugin:
      return KeyCode();
    case eKeyPress:
      //Special case for 4xp bug 62878.  Try to make value of which
      //more closely mirror the values that 4.x gave for RETURN and BACKSPACE
      {
        uint32_t keyCode = KeyCode();
        if (keyCode == NS_VK_RETURN || keyCode == NS_VK_BACK) {
          return keyCode;
        }
        return CharCode();
      }
    default:
      break;
  }

  return 0;
}

NS_IMETHODIMP
KeyboardEvent::GetLocation(uint32_t* aLocation)
{
  NS_ENSURE_ARG_POINTER(aLocation);

  *aLocation = Location();
  return NS_OK;
}

uint32_t
KeyboardEvent::Location()
{
  uint32_t location = mEvent->AsKeyboardEvent()->mLocation;

  if (ShouldResistFingerprinting()) {
    // To resist fingerprinting, hide right modifier keys, as
    // well as the numpad.
    switch (location) {
      case nsIDOMKeyEvent::DOM_KEY_LOCATION_STANDARD :
        location = nsIDOMKeyEvent::DOM_KEY_LOCATION_STANDARD;
        break;
      case nsIDOMKeyEvent::DOM_KEY_LOCATION_LEFT :
        location = nsIDOMKeyEvent::DOM_KEY_LOCATION_LEFT;
        break;
      case nsIDOMKeyEvent::DOM_KEY_LOCATION_RIGHT :
        location = nsIDOMKeyEvent::DOM_KEY_LOCATION_LEFT;
        break;
      case nsIDOMKeyEvent::DOM_KEY_LOCATION_NUMPAD :
        location = nsIDOMKeyEvent::DOM_KEY_LOCATION_STANDARD;
        break;
      default:
        location = nsIDOMKeyEvent::DOM_KEY_LOCATION_STANDARD;
    }
  }

  return location;
}

// static
already_AddRefed<KeyboardEvent>
KeyboardEvent::Constructor(const GlobalObject& aGlobal,
                           const nsAString& aType,
                           const KeyboardEventInit& aParam,
                           ErrorResult& aRv)
{
  nsCOMPtr<EventTarget> target = do_QueryInterface(aGlobal.GetAsSupports());
  RefPtr<KeyboardEvent> newEvent =
    new KeyboardEvent(target, nullptr, nullptr);
  newEvent->InitWithKeyboardEventInit(target, aType, aParam, aRv);

  return newEvent.forget();
}

void
KeyboardEvent::InitWithKeyboardEventInit(EventTarget* aOwner,
                                         const nsAString& aType,
                                         const KeyboardEventInit& aParam,
                                         ErrorResult& aRv)
{
  bool trusted = Init(aOwner);
  InitKeyEvent(aType, aParam.mBubbles, aParam.mCancelable,
               aParam.mView, false, false, false, false,
               aParam.mKeyCode, aParam.mCharCode);
  InitModifiers(aParam);
  SetTrusted(trusted);
  mDetail = aParam.mDetail;
  mInitializedByCtor = true;
  mInitializedWhichValue = aParam.mWhich;

  WidgetKeyboardEvent* internalEvent = mEvent->AsKeyboardEvent();
  internalEvent->mLocation = aParam.mLocation;
  internalEvent->mIsRepeat = aParam.mRepeat;
  internalEvent->mIsComposing = aParam.mIsComposing;
  internalEvent->mKeyNameIndex =
    WidgetKeyboardEvent::GetKeyNameIndex(aParam.mKey);
  if (internalEvent->mKeyNameIndex == KEY_NAME_INDEX_USE_STRING) {
    internalEvent->mKeyValue = aParam.mKey;
  }
  internalEvent->mCodeNameIndex =
    WidgetKeyboardEvent::GetCodeNameIndex(aParam.mCode);
  if (internalEvent->mCodeNameIndex == CODE_NAME_INDEX_USE_STRING) {
    internalEvent->mCodeValue = aParam.mCode;
  }
}

NS_IMETHODIMP
KeyboardEvent::InitKeyEvent(const nsAString& aType,
                            bool aCanBubble,
                            bool aCancelable,
                            mozIDOMWindow* aView,
                            bool aCtrlKey,
                            bool aAltKey,
                            bool aShiftKey,
                            bool aMetaKey,
                            uint32_t aKeyCode,
                            uint32_t aCharCode)
{
  NS_ENSURE_TRUE(!mEvent->mFlags.mIsBeingDispatched, NS_OK);

  UIEvent::InitUIEvent(aType, aCanBubble, aCancelable, aView, 0);

  WidgetKeyboardEvent* keyEvent = mEvent->AsKeyboardEvent();
  keyEvent->InitBasicModifiers(aCtrlKey, aAltKey, aShiftKey, aMetaKey);
  keyEvent->mKeyCode = aKeyCode;
  keyEvent->mCharCode = aCharCode;

  return NS_OK;
}

void
KeyboardEvent::InitKeyboardEvent(const nsAString& aType,
                                 bool aCanBubble,
                                 bool aCancelable,
                                 nsGlobalWindow* aView,
                                 const nsAString& aKey,
                                 uint32_t aLocation,
                                 bool aCtrlKey,
                                 bool aAltKey,
                                 bool aShiftKey,
                                 bool aMetaKey,
                                 ErrorResult& aRv)
{
  NS_ENSURE_TRUE_VOID(!mEvent->mFlags.mIsBeingDispatched);

  UIEvent::InitUIEvent(aType, aCanBubble, aCancelable, aView, 0);

  WidgetKeyboardEvent* keyEvent = mEvent->AsKeyboardEvent();
  keyEvent->InitBasicModifiers(aCtrlKey, aAltKey, aShiftKey, aMetaKey);
  keyEvent->mLocation = aLocation;
  keyEvent->mKeyNameIndex = KEY_NAME_INDEX_USE_STRING;
  keyEvent->mKeyValue = aKey;
}

bool
KeyboardEvent::ShouldResistFingerprinting()
{
  nsCOMPtr<nsIDocument> doc = do_QueryInterface(mOwner);

  if (!doc) {
    nsCOMPtr<nsINode> node = do_QueryInterface(mOwner);

    if (node) {
      doc = node->OwnerDoc();
    } else {
      nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(mOwner);
      if (window) {
        doc = window->GetExtantDoc();
      }
    }
  }

  return !!doc && nsContentUtils::ShouldResistFingerprinting(doc);
}

} // namespace dom
} // namespace mozilla

using namespace mozilla;
using namespace mozilla::dom;

already_AddRefed<KeyboardEvent>
NS_NewDOMKeyboardEvent(EventTarget* aOwner,
                       nsPresContext* aPresContext,
                       WidgetKeyboardEvent* aEvent)
{
  RefPtr<KeyboardEvent> it = new KeyboardEvent(aOwner, aPresContext, aEvent);
  return it.forget();
}
