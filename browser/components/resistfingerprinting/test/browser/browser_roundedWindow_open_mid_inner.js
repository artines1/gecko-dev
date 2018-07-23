/*
 * Bug 1330882 - A test case for opening new windows through window.open() as
 *   rounded size when fingerprinting resistance is enabled. This test is for
 *   middle values.
 */

OpenTest.run([
  {settingWidth: 768, settingHeight: 600, targetWidth: 768, targetHeight: 600},
  {settingWidth: 766, settingHeight: 599, targetWidth: 768, targetHeight: 600},
  {settingWidth: 641, settingHeight: 501, targetWidth: 768, targetHeight: 600}
], false);
