import { baseUrl } from './playwright-tests/config';
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'iPhone SE',
      use: { ...devices['iPhone SE'] },
    },
  ],
  globalTimeout: 5 * 60 * 1000,
  timeout: 5 * 60 * 1000,
  use: {
    baseURL: baseUrl,
  },
  expect: {
    timeout: 5 * 60 * 1000,
  },
});
