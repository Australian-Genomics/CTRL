import { test } from '@playwright/test';
import { expectScreenshot, adminLogin } from '../util';

test('logged in screenshots', async ({ page }) => {
  await adminLogin(page);

  await expectScreenshot(page, '/admin/dashboard', { expectText: 'Welcome to Active Admin' });
});

