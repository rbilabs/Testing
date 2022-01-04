module.exports = {
  roots: ['<rootDir>/src'],
  transform: {
    '^.+\\.tsx?$': 'ts-jest',
  },
  testMatch: ['<rootDir>/src/**/__tests__/**/*.spec.ts'],
  testPathIgnorePatterns: ['dist'],
  moduleFileExtensions: ['ts', 'js', 'json'],
  testEnvironment: 'node',
  collectCoverage: true,
  collectCoverageFrom: ['<rootDir>/src/**/*.{js,ts,tsx}', '!<rootDir>/src/**/__tests__/**/*'],
  coverageReporters: ['html', 'lcov', 'text', 'text-summary'],
  setupFiles: ['<rootDir>/src/__tests__/setup.ts'],
  setupFilesAfterEnv: ['@rbilabs/logger/automock'],
  globals: {
    'ts-jest': {
      diagnostics: false,
    },
  },
};
