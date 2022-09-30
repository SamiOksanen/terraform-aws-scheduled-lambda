import type {Config} from 'jest';

const config: Config = {
    testEnvironment: "node",
    preset: 'ts-jest',
    transform: {
        '^.+\\.(ts|tsx)?$': 'ts-jest',
    },
    coveragePathIgnorePatterns: [
        "/node_modules/"
    ],
    setupFiles: ["dotenv/config"]
};

export default config;