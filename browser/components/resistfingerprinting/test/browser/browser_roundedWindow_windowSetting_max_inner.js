/*
 * Bug 1330882 - A test case for setting window size through window.innerWidth/Height
 *   when fingerprinting resistance is enabled. This test is for maximum values.
 */

WindowSettingTest.run([
  {settingWidth: 1300, settingHeight: 1050, targetWidth: 1280, targetHeight: 1000, initWidth: 128, initHeight: 100},
  {settingWidth: 9999, settingHeight: 9999, targetWidth: 1280, targetHeight: 1000, initWidth: 128, initHeight: 100},
  {settingWidth: 1279, settingHeight: 999, targetWidth: 1280, targetHeight: 1000, initWidth: 128, initHeight: 100}
], false);
