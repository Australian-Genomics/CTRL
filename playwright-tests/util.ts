import { baseUrl } from './config';
import { test, expect, Page, Locator } from '@playwright/test';

const login = async (page: Page) => {
  await page.goto(`${baseUrl}/users/sign_in`);

  // Enter email and password
  await page.getByLabel('Email').fill('testuser@email.com');
  await page.getByLabel('Password', { exact: true }).fill('tester123');
  await page.click("text=/Next/");

  // Enter OTP
  await page.getByLabel('One-time password').fill('000000');

  // Log in
  await Promise.all([
    page.waitForNavigation(),
    page.click("text=/Log in/")
  ]);

  // Check we're logged in
  expect(page.url()).toBe(`${baseUrl}/dashboard`);
};

const adminLogin = async (page: Page) => {
  await page.goto(`${baseUrl}/admin/login`);
  await page.getByLabel('Email*').fill('adminuser@email.com');
  await page.getByLabel('Password*').fill('tester123');
  await page.getByRole('button', { name: 'Login' }).click();
  await page.getByText('Welcome to Active Admin').waitFor({state: 'visible'});
};

const expectScreenshot = async (
  page: Page,
  url: string,
  options?: {
    expectText?: string,
    expectFn?: (page: Page) => Promise<any>,
    mask?: Array<Locator>,
  }
) => {
  const { expectText, expectFn, mask } = options ?? {};
  const maskColor = '#ff00ff';
  const fullPage = true;

  await page.goto(`${baseUrl}${url}`);

  if (expectText) {
    await page.waitForSelector(
      `text=${expectText}`,
      { timeout: 60 * 1000 },
    );
  }

  if (expectFn) {
    await expectFn(page);
  }

  await expect(page).toHaveScreenshot({mask, maskColor, fullPage});
};

export {
  adminLogin,
  expectScreenshot,
  login,
};
