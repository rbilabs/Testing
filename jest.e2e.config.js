const config = require('./jest.config');

module.exports = {
  ...config,
  collectCoverage: false,
  setupFilesAfterEnv: ['<rootDir>/src/e2e/setup.ts'],
  testMatch: ['<rootDir>/src/e2e/**/*.spec.ts'],
  testTimeout: 60000,
};
