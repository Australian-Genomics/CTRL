import { test } from '@playwright/test';
import { expectScreenshot, adminLogin } from '../util';

test('Active Admin - View', async ({ page }) => {
  const mask = [
    page.locator('.row-created_at > td'),
    page.locator('.row-current_sign_in_at > td'),
    page.locator('.row-current_sign_in_ip > td'),
    page.locator('.row-last_sign_in_at > td'),
    page.locator('.row-last_sign_in_ip > td'),
    page.locator('.row-otp_secret > td'),
    page.locator('.row-updated_at > td'),
  ];
  const options = { mask };

  await adminLogin(page);

  await expectScreenshot(page, '/admin/admin_users/1', options);
  await expectScreenshot(page, '/admin/conditional_duo_limitations/1', options);
  await expectScreenshot(page, '/admin/consent_questions/1', options);
  await expectScreenshot(page, '/admin/consent_steps/1', options);
  await expectScreenshot(page, '/admin/glossary_entries/1', options);
  await expectScreenshot(page, '/admin/studies/1', options);
  await expectScreenshot(page, '/admin/survey_configs/1', options);
  await expectScreenshot(page, '/admin/user_column_to_redcap_field_mappings/1', options);
  await expectScreenshot(page, '/admin/users/1', options);
});
