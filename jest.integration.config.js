const config = require('./jest.config');

module.exports = {
  ...config,
  coverageDirectory: '<rootDir>/coverage-integration',
  testMatch: ['<rootDir>/src/**/__tests__/*.integration.ts'],
  testTimeout: 10000,
};
