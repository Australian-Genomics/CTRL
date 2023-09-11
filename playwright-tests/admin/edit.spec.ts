import { test } from '@playwright/test';
import { expectScreenshot, adminLogin } from '../util';

test('Active Admin - Edit', async ({ page }) => {
  const mask = [
    page.locator('#select2-consent_question_consent_group_id-container'),
    page.locator('p.inline-hints'),
  ];
  const options = { mask };

  await adminLogin(page);

  await expectScreenshot(page, '/admin/admin_users/1/edit', options);
  await expectScreenshot(page, '/admin/conditional_duo_limitations/1/edit', options);
  await expectScreenshot(page, '/admin/consent_questions/1/edit', options);
  await expectScreenshot(page, '/admin/consent_steps/1/edit', options);
  await expectScreenshot(page, '/admin/glossary_entries/1/edit', options);
  await expectScreenshot(page, '/admin/studies/1/edit', options);
  await expectScreenshot(page, '/admin/survey_configs/1/edit', options);
  await expectScreenshot(page, '/admin/user_column_to_redcap_field_mappings/1/edit', options);
  await expectScreenshot(page, '/admin/users/1/edit', options);
});
