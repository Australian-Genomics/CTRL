import { test, Page } from '@playwright/test';
import { expectScreenshot, login } from './util';

const waitForYoutubeIframe = async (page: Page) => {
  const youtubeIframe = await page
    .locator('iframe');

  await youtubeIframe.waitFor({
    state: "attached",
  });

  const youtubeIframeElement = await page.locator('iframe').elementHandle();
  if (!youtubeIframeElement) throw Error('iframe element is null');
  const youtubeIframeFrame = await youtubeIframeElement.contentFrame();
  if (!youtubeIframeFrame) throw Error('iframe is null');
  const youtubeIframeText = youtubeIframeFrame
    .getByText('Welcome to CTRL');

  await youtubeIframeText.waitFor({
    state: "attached",
  });
};

test('logged in screenshots', async ({ page }) => {
  await login(page);

  await expectScreenshot(page, '/dashboard', { expectText: 'Welcome testuser' });
  await expectScreenshot(page, '/glossary', { expectText: 'Glossary' });
  await expectScreenshot(page, '/users/profile', { expectText: 'First Name' });
  await expectScreenshot(page, '/contact_us', { expectText: 'Please enter your message' });
  await expectScreenshot(page, '/users/profile/edit', { expectText: 'Edit personal details' });
  await expectScreenshot(page, '/consent-form?surveystep=1', { expectFn: waitForYoutubeIframe });
  await expectScreenshot(page, '/consent-form?surveystep=2', { expectText: 'Step 2 of 5' });
  await expectScreenshot(page, '/consent-form?surveystep=3', { expectText: 'Step 3 of 5' });
  await expectScreenshot(page, '/consent-form?surveystep=4', { expectText: 'Step 4 of 5' });
  await expectScreenshot(page, '/consent-form?surveystep=5', { expectText: 'Step 5 of 5' });
});

