export const handler = async () => {
    if (process.env.TEST_ENV_VARIABLE_ONE && process.env.TEST_ENV_VARIABLE_TWO) {
        console.log(process.env.TEST_ENV_VARIABLE_ONE, process.env.TEST_ENV_VARIABLE_TWO);
    } else {
        throw new Error('Env variables missing');
    }
}
