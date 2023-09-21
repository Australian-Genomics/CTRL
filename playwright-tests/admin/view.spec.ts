import { test } from '@playwright/test';
import { expectScreenshot, adminLogin } from '../util';

test('Active Admin - View', async ({ page }) => {
  // We replace the HTML nodes which contain data we can't easily control during
  // testing.
  const replacer = (node: HTMLElement): void => {
    node.replaceWith(document.createElement('td'))
  };

  const replace = [
    { replacer, selector: '.row-created_at > td' },
    { replacer, selector: '.row-current_sign_in_at > td' },
    { replacer, selector: '.row-current_sign_in_ip > td' },
    { replacer, selector: '.row-last_sign_in_at > td' },
    { replacer, selector: '.row-last_sign_in_ip > td' },
    { replacer, selector: '.row-otp_required_for_login > td' },
    { replacer, selector: '.row-otp_secret > td' },
    { replacer, selector: '.row-updated_at > td' },
  ];

  const options = { replace };

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
