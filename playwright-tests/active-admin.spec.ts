import { test, expect } from '@playwright/test';
import { baseUrl } from './config';

test('the user can log into active admin', async ({ page }) => {
  await page.goto(`${baseUrl}/admin/login`);
  await page.getByLabel('Email*').fill('adminuser@email.com');
  await page.getByLabel('Password*').fill('tester123');
  await page.getByRole('button', { name: 'Login' }).click();
  await page.getByText('Welcome to Active Admin').waitFor({state: 'visible'});
});
