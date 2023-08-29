import { test } from '@playwright/test';
import { expectScreenshot } from './util';

test('logged out screenshots', async ({ page }) => {
  await expectScreenshot(page, '/', { expectText: 'Register Now' });
  await expectScreenshot(page, '/users/sign_up', { expectText: 'Register Now' });
  await expectScreenshot(page, '/users/sign_in', { expectText: 'Forgot?' } );
  await expectScreenshot(page, '/users/password/new', { expectText: 'Send Request' });
});
