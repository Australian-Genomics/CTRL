import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  globalTimeout: 5 * 60 * 1000,
  timeout: 5 * 60 * 1000,
  use: {
    baseURL: "http://web:3000",
  },
  expect: {
    timeout: 5 * 60 * 1000,
  },
});
