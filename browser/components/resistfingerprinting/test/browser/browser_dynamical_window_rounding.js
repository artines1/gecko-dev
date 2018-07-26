/**
 * Bug 1407366 - A test case for reassuring the size of the content viewport is quantized
 *   if the window is resized to any sizes when fingerprinting resistance is enabled.
 */

const TEST_PATH = "http://example.net/browser/browser/components/resistfingerprinting/test/browser/";

const TESTCASES = [
  {width: 1280, height: 1000},
  {width: 1500, height: 1050},
  {width: 1100, height: 799},
  {width: 9999, height: 9999},
  {width: 500,  height: 350},
];

add_task(async function setup() {
  await SpecialPowers.pushPrefEnv({"set":
    [["privacy.resistFingerprinting", true]]
  });
});

add_task(async function test_dynamical_window_rounding() {
  let browserContainer = gBrowser.getBrowserContainer();
  let chromeUIWidth = window.outerWidth - browserContainer.clientWidth;
  let chromeUIHeight = window.outerHeight - browserContainer.clientHeight;
  let availWidth = window.screen.availWidth;
  let availHeight = window.screen.availHeight;

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser, TEST_PATH + "file_dummy.html");

  for (let {width, height} of TESTCASES) {
    let browserWidth = (width <= availWidth) ? (width - chromeUIWidth) :
                                               (availWidth - chromeUIWidth);
    let browserHeight = (height <= availHeight) ? (height - chromeUIHeight) :
                                                  (availHeight - chromeUIHeight);

    let targetWidth = browserWidth - (browserWidth % 128);
    let targetHeight = browserHeight - (browserHeight % 100);

    let testParams = {
      targetWidth,
      targetHeight
    };

    window.resizeTo(width, height);

    await ContentTask.spawn(tab.linkedBrowser, testParams, (aInput) => {
      is(content.screen.width, aInput.targetWidth,
        "The screen.width has a correct rounded value");
      is(content.innerWidth, aInput.targetWidth,
        "The window.innerWidth has a correct rounded value");

      is(content.screen.height, aInput.targetHeight,
        "The screen.height has a correct rounded value");
      is(content.innerHeight, aInput.targetHeight,
        "The window.innerHeight has a correct rounded value");
    });
  }

  BrowserTestUtils.removeTab(tab);
});
