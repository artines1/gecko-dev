/*
 * Bug 1330882 - A test case for setting window size through window.outerWidth/Height
 *   when fingerprinting resistance is enabled. This test is for minimum values.
 */

WindowSettingTest.run([
  {settingWidth: 127, settingHeight: 99, targetWidth: 128, targetHeight: 100, initWidth: 1280, initHeight: 1000},
  {settingWidth: 10, settingHeight: 10, targetWidth: 128, targetHeight: 100, initWidth: 1280, initHeight: 1000}
], true);
