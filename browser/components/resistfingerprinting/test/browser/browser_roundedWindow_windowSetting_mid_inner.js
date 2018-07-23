/*
 * Bug 1330882 - A test case for setting window size through window.innerWidth/Height
 *   when fingerprinting resistance is enabled. This test is for middle values.
 */

WindowSettingTest.run([
  {settingWidth: 768, settingHeight: 600, targetWidth: 768, targetHeight: 600, initWidth: 128, initHeight: 100},
  {settingWidth: 766, settingHeight: 599, targetWidth: 768, targetHeight: 600, initWidth: 128, initHeight: 100},
  {settingWidth: 641, settingHeight: 501, targetWidth: 768, targetHeight: 600, initWidth: 128, initHeight: 100}
], false);
