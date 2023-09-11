import { test } from '@playwright/test';
import { expectScreenshot, adminLogin } from '../util';

test('Active Admin - Index', async ({ page }) => {
  const mask = [
    page.locator('td.col-created_at'),
    page.locator('td.col-current_sign_in_at'),
    page.locator('td.col-sign_in_count'),
    page.locator('td.col-updated_at'),
  ];
  const options = { mask };

  await adminLogin(page);

  await expectScreenshot(page, '/admin/dashboard', options);
  await expectScreenshot(page, '/admin/admin_users', options);
  await expectScreenshot(page, '/admin/api_users', options);
  await expectScreenshot(page, '/admin/conditional_duo_limitations', options);
  await expectScreenshot(page, '/admin/consent_questions', options);
  await expectScreenshot(page, '/admin/consent_steps', options);
  await expectScreenshot(page, '/admin/documentation', options);
  await expectScreenshot(page, '/admin/glossary_entries', options);
  await expectScreenshot(page, '/admin/import_export', options);
  await expectScreenshot(page, '/admin/question_answers', options);
  await expectScreenshot(page, '/admin/studies', options);
  await expectScreenshot(page, '/admin/survey_configs', options);
  await expectScreenshot(page, '/admin/user_column_to_redcap_field_mappings', options);
  await expectScreenshot(page, '/admin/users', options);
});
